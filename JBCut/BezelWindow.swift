//
//  BezelWindow.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/3.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

protocol BezelWindowDelegate {
    func metaKeysReleased()
}

class BezelWindow: NSPanel {
    
    var textField: NSTextField!
    var bezeDelegate: BezelWindowDelegate?

    
    override var canBecomeKey: Bool {
        return true
    }
    
    init(cusSzie: NSRect) {
        super.init(contentRect: cusSzie,
                   styleMask: NSWindow.StyleMask.borderless,
                   backing: NSWindow.BackingStoreType.buffered,
                   defer: false)
        
        
        self.isOpaque = true
        self.alphaValue = 1.0
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.backgroundColor = NSColor.lightGray
        self.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
        
        let flipView : FlipView = FlipView.init(frame: self.contentView?.frame ?? NSMakeRect(0, 0, 80, 80))
        self.contentView?.addSubview(flipView)
        
        textField = NSTextField.init(frame: flipView.bounds)
        textField.textColor = NSColor.blue
        textField.font = NSFont.systemFont(ofSize: 17)
        flipView.addSubview(textField)
    }
    
    public func showTextString(showString: String) {
        textField.stringValue = showString
    }
    
    override func flagsChanged(with event: NSEvent) {
        if !(event.modifierFlags.contains(.command)) &&
            !(event.modifierFlags.contains(.option)) &&
            !(event.modifierFlags.contains(.control)) &&
            !(event.modifierFlags.contains(.shift)) &&
            self.bezeDelegate != nil {
            self.bezeDelegate?.metaKeysReleased()
        }
    }
}

class FlipView: NSView {
    override var isFlipped: Bool {
        get {
            return true
        }
    }
}
