//
//  BezelWindow.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/3.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class BezelWindow: NSPanel {
    
    init(cusSzie: NSRect) {
        super.init(contentRect: cusSzie,
                   styleMask: NSWindow.StyleMask.borderless,
                   backing: NSWindow.BackingStoreType.buffered,
                   defer: false)
        
        
        self.isOpaque = true
        self.alphaValue = 1.0
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.backgroundColor = NSColor.red
        self.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
    }
}
