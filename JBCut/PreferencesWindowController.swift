//
//  PreferencesWindowController.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSToolbarDelegate {

    @IBOutlet weak var bgView: NSView!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name()
    }
    
    var toolbarTabs: Array<Dictionary<String, String>> {
        let toolbarItemsArray =
            [
                ["title":"General","icon":"net.sf.jumpcut.preferences.general.tiff","class":"DepartmentViewController","identifier":"DepartmentViewController"],
                ["title":"Hotkeys","icon":"net.sf.jumpcut.preferences.hotkey.tiff","class":"AccountViewController","identifier":"AccountViewController"],
                ["title":"Appearance","icon":"net.sf.jumpcut.preferences.appearance.tiff","class":"EmployeeViewController","identifier":"EmployeeViewController"]
        ];
        return toolbarItemsArray;
    }
    var toolbarTabsIdentifiers: [NSToolbarItem.Identifier] = [NSToolbarItem.Identifier]()
    
    
    var toolbar:NSToolbar!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.bgView.wantsLayer = true
        self.bgView.layer?.backgroundColor = NSColor.white.cgColor
        
        for dic in toolbarTabs {
            toolbarTabsIdentifiers.append(NSToolbarItem.Identifier(rawValue: dic["identifier"] ?? ""))
        }
        
//        toolbar = NSToolbar(identifier: NSToolbar.Identifier())
        toolbar = NSToolbar(identifier:"ScreenNameToolbarIdentifier")

        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        self.window?.toolbar = toolbar;
    }
    
    //MARK: - toolbar delegate
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var infoDic: Dictionary<String, String> = Dictionary<String, String>()
        for dictionary in toolbarTabs {
            if dictionary["identifier"] == itemIdentifier.rawValue {
                infoDic = dictionary;
                break;
            }
        }
        
        let iconImage = NSImage(named: infoDic["icon"] ?? "")
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        toolbarItem.label = infoDic["title"]!
        toolbarItem.image = iconImage
        toolbarItem.target = self
        toolbarItem.action = Selector(("viewSelected:"))
        return toolbarItem;
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarTabsIdentifiers
    }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return self.toolbarDefaultItemIdentifiers(toolbar)
        return toolbarTabsIdentifiers
    }
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return self.toolbarDefaultItemIdentifiers(toolbar)
        return toolbarTabsIdentifiers
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        print("toolbarWillAddItem")
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        print("toolbarDidRemoveItem")
    }
    
    
    @objc func viewSelected(sender: NSToolbarItem) {
        print("item selected")
    }
}
//optional func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
//
//optional func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
//
//optional func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
//
//optional func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
//
//optional func toolbarWillAddItem(_ notification: Notification)
//
//optional func toolbarDidRemoveItem(_ notification: Notification)
