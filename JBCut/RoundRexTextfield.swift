//
//  RoundRexTextfield.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/8.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class RoundRexTextfield: NSTextField {

    override var isOpaque: Bool {
        return false
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        let roundedRec = NSBezierPath().getBeizerPath(aRect: dirtyRect, radius: 8)
        self.backgroundColor?.set()
        roundedRec.fill()
        
        self.drawsBackground = false
        // We might eventually want to pass [super drawRect] something smaller than rect, to ensure that we don't bleed over the corners
        super.draw(dirtyRect)
        self.drawsBackground = true
        
    }
    
}
