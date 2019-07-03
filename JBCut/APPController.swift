//
//  APPController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/2.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon

class APPController: NSObject,NSMenuDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var clipArray = [String]();
    var lastChangeCount = 0;
    
    lazy var beze: BezelWindow = {
        () -> BezelWindow in
        let rectSize = NSRect(x: 100, y: 100, width: 200, height: 200)
        let beze = BezelWindow(cusSzie: rectSize)
        return beze
    }()
    
    
    override func awakeFromNib() {
        let button = statusItem.button
        button?.image = NSImage(named: "StatusBarButtonImage")
        
        
        statusItem.menu = mainMenu
        mainMenu.delegate = self
        
        /*let copyTimer = */Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        self.registerHotKey()
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
            clipArray.first != clipString
        {
            clipArray.insert(clipString, at: 0)
            print("new added")
        }
        lastChangeCount = board.changeCount
        
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu will open")
    }
    
    func registerHotKey() {
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (nextHander, theEvent, userData) -> OSStatus in
            print("key print")
            return noErr
        }, 1, &eventType, nil, nil)
        
        
        let hotKeyID = EventHotKeyID(signature: 1, id: 1)
        var hotkey: EventHotKeyRef? = nil
        
        RegisterEventHotKey(UInt32(kVK_ANSI_L), UInt32(cmdKey|shiftKey), hotKeyID, GetApplicationEventTarget(), OptionBits(0), &hotkey)
    }
    
    
    func createShowWindow () {
        self.beze.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func showWindow(_ sender: Any) {
        createShowWindow()
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
