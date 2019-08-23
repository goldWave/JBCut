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
        return NSNib.Name("PreferencesWindowController")
    }
    
    private var toolbarTabsIdentifiers: [NSToolbarItem.Identifier] = [NSToolbarItem.Identifier]()
    
    private  var toolbar:NSToolbar!
    
    var currentVC: NSViewController!
    
    var currentViewIdentifier = ""
    
    private var toolbarTabs: Array<Dictionary<String, String>> {
        let toolbarItemsArray =
            [
                ["title": "General",
                 "icon": "net.sf.jumpcut.preferences.general.tiff",
                 "class": JBConstants.generalIdentidier,
                 "identifier": JBConstants.generalIdentidier],
                ["title": "Hotkeys",
                 "icon": "net.sf.jumpcut.preferences.hotkey.tiff",
                 "class": JBConstants.hotkeysIdentidier,
                 "identifier": JBConstants.hotkeysIdentidier],
                ["title": "Appearance",
                 "icon": "net.sf.jumpcut.preferences.appearance.tiff",
                 "class": JBConstants.appearanceIdentidier,
                 "identifier": JBConstants.appearanceIdentidier]
        ];
        return toolbarItemsArray;
    }
    override func windowDidLoad() {
        super.windowDidLoad()

        for dic in toolbarTabs {
            toolbarTabsIdentifiers.append(NSToolbarItem.Identifier(rawValue: dic["identifier"] ?? ""))
        }
        
        toolbar = NSToolbar(identifier:"ScreenNameToolbarIdentifier")
        
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        toolbar.selectedItemIdentifier = toolbarTabsIdentifiers[0]
        self.window?.toolbar = toolbar;
        loadViewWithIdentifier(viewIdentifier: toolbar.selectedItemIdentifier?.rawValue ?? "", withAnimation: false)
        
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
        toolbarItem.isEnabled = true
        toolbarItem.action = #selector(toolbarDidSelected)
        
        return toolbarItem;
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarTabsIdentifiers
    }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
//        print("toolbarWillAddItem")
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
//        print("toolbarDidRemoveItem")
    }
    
    //MARK: - view action
    
    @objc func toolbarDidSelected(sender: NSToolbarItem) {
        loadViewWithIdentifier(viewIdentifier: sender.itemIdentifier.rawValue, withAnimation: true)
    }
    
    func loadViewWithIdentifier(viewIdentifier: String, withAnimation: Bool) {
        
        if currentViewIdentifier == viewIdentifier {
            return
        }
        
        currentViewIdentifier = viewIdentifier;
        
        switch viewIdentifier {
        case JBConstants.generalIdentidier:
            currentVC = GeneralViewController.init()
        case JBConstants.hotkeysIdentidier:
            currentVC = HotkeysViewController.init()
        case JBConstants.appearanceIdentidier:
            currentVC = AppearanceViewController.init()
        default:
            currentVC = GeneralViewController.init()
        }
        
        let windowRect = self.window?.frame
        let viewRect = currentVC.view.frame
        
        window?.contentView = currentVC.view
        let yPos = windowRect!.origin.y + (windowRect!.size.height - viewRect.size.height)
        let newFrame = NSMakeRect(windowRect!.origin.x, yPos, viewRect.size.width, viewRect.size.height)
        
        window?.setFrame(newFrame, display: true, animate: withAnimation)
    }
}
