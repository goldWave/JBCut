//
//  APPController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/2.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

@NSApplicationMain
class APPController: NSObject,NSMenuDelegate, HotKeyDelegate, NSApplicationDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var clipArray = [ClipData]();
    var lastChangeCount = 0;
    var nowShowIndex = 0;
    var filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]  + "/clipData.plist";
    
    
    lazy var beze: BezelWindow = {
        () -> BezelWindow in
        let rectSize = NSRect(x: 100, y: 100, width: 200, height: 200)
        let beze = BezelWindow(cusSzie: rectSize)
        return beze
    }()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("applicationDidFinishLaunching")
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
        
        let board = NSPasteboard.general;
        let type = board.availableType(from: [.string])
        
        guard type != nil else {
            return;
        }
        
        let clipString = board.string(forType: NSPasteboard.PasteboardType.string)!
        
        if lastChangeCount != board.changeCount &&
            !clipString.isEmpty &&
            clipArray.first?.clipString != clipString
        {
            let data = ClipData.init()
            data.clipString = clipString
            data.timeStamp = Int(NSDate().timeIntervalSince1970)
            clipArray.insert(data, at: 0)
            writeDateToFile()
        }
        lastChangeCount = board.changeCount
        
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu will open")
    }
        
    func createShowWindow(isNext: Bool) {

        var string: String = "无数据"
        if nowShowIndex < 0 {
            print()
        }
        
        nowShowIndex = nowShowIndex >= clipArray.count ? (clipArray.count - 1) : nowShowIndex
        nowShowIndex = nowShowIndex < 0 ? 0 : nowShowIndex
        
        if clipArray.count > nowShowIndex && nowShowIndex >= 0 {
            string = clipArray[nowShowIndex].clipString
            string =  String.init(format: "index:%i, total:%i\n%@", nowShowIndex + 1, clipArray.count, string)
            
            print(nowShowIndex)
            nowShowIndex += isNext ? 1 : -1
            print(nowShowIndex)
            print("\n\n")
        }
        self.beze.showTextString(showString: string)
        NSApp.activate(ignoringOtherApps: true)
        
        self.beze.makeKeyAndOrderFront(nil)
    }
    
    func hotKeyCliked(isNext: Bool) {
        self.createShowWindow(isNext: isNext);
    }

    func writeDateToFile() {
        NSKeyedArchiver.archiveRootObject(clipArray, toFile: filePath)
    }
    
}
