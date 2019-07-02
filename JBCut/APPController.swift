//
//  APPController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/2.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class APPController: NSObject,NSMenuDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var clipArray = [String]();
    var lastChangeCount = 0;
    
    
    override func awakeFromNib() {
        let button = statusItem.button
        button?.image = NSImage(named: "StatusBarButtonImage")
        
        
        statusItem.menu = mainMenu
        mainMenu.delegate = self
        print("T##items: Any...##Any")
        
        /*let copyTimer = */Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
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
        print(clipString, board.changeCount, clipArray.count)

    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu will open")
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
