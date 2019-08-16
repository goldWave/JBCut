//
//  JBRecordView.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class JBRecordView: NSView {
        
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
    
        self.wantsLayer = true
        //        self.layer?.backgroundColor = NSColor.red.cgColor
        
        self.layer?.borderWidth = 2
        self.layer?.cornerRadius = 5
        self.layer?.borderColor = NSColor.orange.cgColor
        drawKeyText()
    }
    
    override func keyDown(with event: NSEvent) {
        
        if JBShortcutManager.manager.praseEvent(keyEvent: event) {

            needsDisplay =   true
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        print("mouseUp")
    }
    
    func drawKeyText() {
        let attributeDict: [NSAttributedString.Key : Any] = [
            //            .font: Font!,
            .foregroundColor: NSColor.red,
            //            .paragraphStyle: textStyle,
        ]
        var totalString = JBShortcutManager.manager.modifierFlagsString
        totalString = totalString + JBShortcutManager.manager.keyCodeString
        totalString.draw(in: NSRect(x: 20, y: 5, width: 200, height: 20), withAttributes: attributeDict)
    }
    
}
