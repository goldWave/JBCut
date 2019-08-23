//
//  JBAboutWindowController.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/23.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class JBAboutWindowController: NSWindowController {

    @IBOutlet weak var versionLabel: NSTextField!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("JBAboutWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
           versionLabel.stringValue = "version " + version
        }
    }
    
}
