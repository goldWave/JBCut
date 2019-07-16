//
//  PreferencesWindowController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSToolbarDelegate {

    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name()
    }
    
    var toolbarTabs: Array<Dictionary<String, String>> {
        let toolbarItemsArray =
            [
                ["title":"Find Departments","icon":"NSPreferencesGeneral","class":"DepartmentViewController","identifier":"DepartmentViewController"],
                ["title":"Find Accounts","icon":"NSFontPanel","class":"AccountViewController","identifier":"AccountViewController"],
                ["title":"Find Employees","icon":"NSAdvanced","class":"EmployeeViewController","identifier":"EmployeeViewController"]
        ];
        return toolbarItemsArray;
    }
    var toolbarTabsIdentifiers: [String] = []
    
    
    var toolbar:NSToolbar!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()

        for dic in toolbarTabs {
            toolbarTabsIdentifiers.append(dic["identifier"] ?? "")
        }
        
        toolbar = NSToolbar(identifier: NSToolbar.Identifier())
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        self.window?.toolbar = toolbar;
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var infoDic: Dictionary<String, String> = Dictionary<String, String>()
        for dictionary in toolbarTabs {
            dictionary
        }
        
    }
}
