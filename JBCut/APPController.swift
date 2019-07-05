//
//  APPController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/2.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

@NSApplicationMain
class APPController: NSObject, NSMenuDelegate, HotKeyDelegate, NSApplicationDelegate, BezelWindowDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var clipArray = [ClipData]();
    var lastChangeCount = 0;
    var nowShowIndex = 0;
    var filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]  + "/clipData.plist";
    let limitClipCount = 20
    let jbPastBoard = NSPasteboard.general;
    
    lazy var beze: BezelWindow = {
        () -> BezelWindow in
        
//        NSSize windowSize = NSMakeSize(325.0, 325.0);
//        NSSize screenSize = [[NSScreen mainScreen] frame].size;
//        NSRect windowFrame = NSMakeRect( (screenSize.width - windowSize.width) / 2,
//                                         (screenSize.height - windowSize.height) / 3,
//                                         windowSize.width, windowSize.height );
        let bezeSize = NSSize(width: 325, height: 325)
        let scrrenSize = NSScreen.main?.frame.size
        let rectSize = NSRect(x: ((scrrenSize?.width ?? 1000) - bezeSize.width) * 0.5, y: ((scrrenSize?.height ?? 1000) - bezeSize.height) * 0.5, width: bezeSize.width, height: bezeSize.height)
        let beze = BezelWindow(cusSzie: rectSize)
        beze.bezeDelegate = self
        return beze
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("applicationDidFinishLaunching")
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        hideBezeWindow()
    }
    
    override func awakeFromNib() {
        print(filePath)
        
        let button = statusItem.button
        button?.image = NSImage(named: "StatusBarButtonImage")
        
        statusItem.menu = mainMenu
        mainMenu.delegate = self
        
        /*let copyTimer = */Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        HotKeyCenter.shared.registerHotKey()
        HotKeyCenter.shared.delegate = self
        
        if let unarchivedData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ClipData] {
            clipArray = unarchivedData
        }
        
        print("")
    }
    
    @IBAction func quitButtonClick(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func timerFired() {
        
        let type = jbPastBoard.availableType(from: [.string])
        
        guard type != nil else {
            return;
        }
        
        let clipString = jbPastBoard.string(forType: NSPasteboard.PasteboardType.string)!
        
        if lastChangeCount != jbPastBoard.changeCount &&
            !clipString.isEmpty &&
            clipArray.first?.clipString != clipString
        {
            let data = ClipData.init()
            data.clipString = clipString
            data.timeStamp = Int(NSDate().timeIntervalSince1970)
            clipArray.insert(data, at: 0)
            checkIsOutData()
            writeDateToFile()
        }
        lastChangeCount = jbPastBoard.changeCount
        
    }
    
    func checkIsOutData() {
        if clipArray.count > limitClipCount {
            clipArray.removeSubrange(limitClipCount..<clipArray.count)
        }
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu will open")
    }
    
    func createShowWindow() {
        
        if self.beze.isVisible {
            return
        }
        var string: String = "无数据"
        if clipArray.count > nowShowIndex && nowShowIndex >= 0 {
            string = clipArray[nowShowIndex].clipString
            string = String.init(format: "index:%i, total:%i\n%@", nowShowIndex + 1, clipArray.count, string)
        }
        self.beze.showTextString(showString: string)
        NSApp.activate(ignoringOtherApps: true)
        self.beze.makeKeyAndOrderFront(nil)
    }
    
    func hideBezeWindow() {
        self.beze.orderOut(nil)
        nowShowIndex = 0
    }
    
    func writeDateToFile() {
        NSKeyedArchiver.archiveRootObject(clipArray, toFile: filePath)
    }
    
    @objc func appHide() {
        hideBezeWindow()
        NSApp.hide(self)
    }
    
    func pasteFromStack() {
        self.perform(#selector(appHide), with: nil, afterDelay: 0.2)
        moveClipDateToTop(index: nowShowIndex)
        self.perform(#selector(fakeCommandV), with: nil, afterDelay: 0.2)
    }
    
    @objc func fakeCommandV() {
        let source = CGEventSource(stateID: .combinedSessionState)
        //disabel local keyboard click
        source?.setLocalEventsFilterDuringSuppressionState([.permitLocalKeyboardEvents, .permitSystemDefinedEvents], state: .eventSuppressionStateSuppressionInterval)
        //press command + v
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        keyDown?.flags = .maskCommand
        //release command + v
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)
        keyUp?.flags = .maskCommand
        //post paste command
        keyDown?.post(tap: .cgAnnotatedSessionEventTap)
        keyUp?.post(tap: .cgAnnotatedSessionEventTap)
    }
    
    func moveClipDateToTop(index: Int) {
        guard clipArray.count > index else {return}
        let selectData = clipArray.remove(at: index)
        clipArray.insert(selectData, at: 0)
        
        jbPastBoard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        jbPastBoard.setString(clipArray[0].clipString, forType: NSPasteboard.PasteboardType.string)
        writeDateToFile()
    }
    
    //MARK: - HotKeyDelegate
    func hotKeyCliked(isNext: Bool) {
        if self.beze.isVisible {
            self.stackDownOrUp(isNext: isNext)
        } else {
           self.createShowWindow()
        }
    }
    
    func stackDownOrUp(isNext: Bool)  {
        var string: String = "无数据"
        if !self.beze.isVisible {
            self.createShowWindow()
            return
        }
        nowShowIndex += isNext ? 1 : -1
        //protect the index out of range
        nowShowIndex = nowShowIndex >= clipArray.count ? (clipArray.count - 1) : nowShowIndex
        nowShowIndex = nowShowIndex < 0 ? 0 : nowShowIndex
        
        if clipArray.count > nowShowIndex && nowShowIndex >= 0 {
            string = clipArray[nowShowIndex].clipString
            string =  String.init(format: "index:%i, total:%i\n%@", nowShowIndex + 1, clipArray.count, string)
        }
        self.beze.showTextString(showString: string)
    }
    
    //MARK: - BezelWindowDelegate
    func metaKeysReleased() {
        if self.beze.isVisible {
          pasteFromStack()
        }
    }
    
}
