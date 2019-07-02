//
//  AppDelegate.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/2.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let button = statusItem.button
        button?.image = NSImage(named: "StatusBarButtonImage")
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

