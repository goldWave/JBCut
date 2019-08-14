//
//  AppDelegate.swift
//  JBCut Helper
//
//  Created by 任金波 on 2019/8/14.
//  Copyright © 2019 任金波. All rights reserved.
//


/*
 Thanks for the login item method for below link
 http://martiancraft.com/blog/2015/01/login-items/
 https://medium.com/@hoishing/adding-login-items-for-macos-7d76458f6495
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    /*
     That’s it for the Helper application…
     its sole job is to find out the path for the main application,
     launch it, and then terminate itself.
     */
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == "com.jimbo.JBCut"
        }
        
        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            NSWorkspace.shared.launchApplication(path as String)
        }
        NSApp.terminate(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

