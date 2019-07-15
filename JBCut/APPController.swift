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
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var clipArray = [ClipData]();
    private var lastChangeCount = 0;
    private var nowShowIndex = 0;
    private var filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]  + "/clipData.plist";
    private let limitClipCount = 20
    private let jbPastBoard = NSPasteboard.general;
    private var isMenuOpened = false
    
    lazy var beze: BezelWindow = {
        () -> BezelWindow in
        let bezeSize = NSSize(width: 325, height: 270)
        let rectSize = NSRect(x: 0, y: 0, width: bezeSize.width, height: bezeSize.height)
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
        button?.image = NSImage(named: "menu_image")
        
        statusItem.menu = mainMenu
        statusItem.highlightMode = true
        statusItem.isEnabled = true
        
        mainMenu.delegate = self
        
        /*let copyTimer = */Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        HotKeyCenter.shared.registerHotKey()
        HotKeyCenter.shared.delegate = self
        GlobalVariable.shared.readDataFronUserDefault()
        if let unarchivedData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ClipData] {
            clipArray = unarchivedData
        }
        updateClipMenu()
    }
    
    @IBAction func quitButtonClick(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func timerFired() {
        
        let type = jbPastBoard.availableType(from: [.string])
        
        guard type != nil else {
            return;
        }
        let clipString = jbPastBoard.string(forType: NSPasteboard.PasteboardType.string) ?? ""
        
        if lastChangeCount != jbPastBoard.changeCount &&
            !clipString.isEmpty &&
            clipArray.first?.clipString != clipString
        {
            print("add new clip data")
            let data = ClipData.init()
            data.clipString = clipString
            data.timeStamp = Int(NSDate().timeIntervalSince1970)
            clipArray.insert(data, at: 0)
            checkIsOutData()
            writeDateToFile()
            
            if isMenuOpened {updateClipMenu()}
        }
        lastChangeCount = jbPastBoard.changeCount
        
    }
    
    func checkIsOutData() {
        if clipArray.count > limitClipCount {
            clipArray.removeSubrange(limitClipCount..<clipArray.count)
        }
    }
    
    func createShowWindow() {
        
        if self.beze.isVisible {
            return
        }
        if clipArray.count > nowShowIndex && nowShowIndex >= 0 {
            let indexString = String.init(format: "%i of %i", nowShowIndex + 1, clipArray.count)
            self.beze.setCurrentData(data: clipArray[nowShowIndex], indexString: indexString)
        }
        
        self.beze.adjustWindowToCenter()
        
        NSApp.activate(ignoringOtherApps: true)
        self.beze.makeKeyAndOrderFront(nil)
    }
    
    func hideBezeWindow() {
        if self.beze.isVisible {
            self.beze.orderOut(nil)
        }
        nowShowIndex = 0
    }
    
    func writeDateToFile() {
        NSKeyedArchiver.archiveRootObject(clipArray, toFile: filePath)
    }
    
    @objc func appHide() {
        hideBezeWindow()
        NSApp.hide(self)
    }
    
    func updateClipMenu() {
        print("updateClipMenu")
        let menuItems = mainMenu.items
        
        for item in menuItems {
            if item.isSeparatorItem {
                break;
            } else  {
                mainMenu.removeItem(item)
            }
        }
        
        let reveredArrary = getMenuArray()
        for (index, data) in reveredArrary.enumerated() {
            
            var keyEquivalent: String = ""
            if reveredArrary.count > 10 {
                if (reveredArrary.count - index - 1) >= 10 {
                    keyEquivalent = ""
                } else {
                    keyEquivalent = String(reveredArrary.count - index - 1)
                }
            } else {
                keyEquivalent = String(reveredArrary.count - index - 1)
            }
            
            let item = NSMenuItem.init(title: data.displayMenuString, action: #selector(processMenuClippingSelection(sender:)), keyEquivalent: keyEquivalent)
            
            item.target = self
            item.isEnabled = true
            
            mainMenu.insertItem(item, at: 0) 
        }
    }
    
    func getMenuArray() -> [ClipData] {
        let currentCount = min(clipArray.count, GlobalVariable.shared.clipMenuCount)
        return clipArray[0..<currentCount].reversed()
    }
    
    //MARK: - menu clicked
    @objc func processMenuClippingSelection(sender: NSMenuItem) {
        nowShowIndex = sender.menu?.index(of: sender) ?? 0
        self.perform(#selector(appHide), with: nil, afterDelay: 0)
        moveClipDateToTop(index: nowShowIndex)
        self.perform(#selector(fakeCommandV), with: nil, afterDelay: 0.2)
    }
    
    @IBAction func clearAllData(_ sender: Any) {
        self.clipArray.removeAll()
        writeDateToFile()
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
    }
    
    //MARK: - hotkey cliked
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
        if !self.beze.isVisible {
            self.createShowWindow()
            return
        }
        nowShowIndex += isNext ? 1 : -1
        //protect the index out of range
        nowShowIndex = nowShowIndex >= clipArray.count ? (clipArray.count - 1) : nowShowIndex
        nowShowIndex = nowShowIndex < 0 ? 0 : nowShowIndex
        
        if clipArray.count > nowShowIndex && nowShowIndex >= 0 {
            let indexString = String.init(format: "%i of %i", nowShowIndex + 1, clipArray.count)
            self.beze.setCurrentData(data: clipArray[nowShowIndex], indexString: indexString)
        }
        
    }
    
    //MARK: - BezelWindowDelegate
    func metaKeysReleased() {
        if self.beze.isVisible {
            pasteFromStack()
        }
    }
    
    //MARK: - NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        print("menu will open")
        timerFired()
        updateClipMenu()
        isMenuOpened = true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        print("menu did open")
        isMenuOpened = false
    }
}
