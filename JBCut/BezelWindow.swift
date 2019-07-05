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
    
    private var textField: RoundRexTextfield!
    var bezeDelegate: BezelWindowDelegate?
    
    
    override var canBecomeKey: Bool {
        return true
    }
    
    init(cusSzie: NSRect) {
        super.init(contentRect: cusSzie,
                   styleMask: NSWindow.StyleMask.borderless,
                   backing: NSWindow.BackingStoreType.buffered,
                   defer: false)
        
        
        self.level = NSWindow.Level.screenSaver
        self.isOpaque = false
        self.alphaValue = 1.0
        self.isOpaque = false
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.backgroundColor = sizeBezelBackground(radius: 25, alpha: 0.85, bgSize: NSSize(width: 350, height: 350))
        self.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
        
        textField = RoundRexTextfield.init(frame: NSMakeRect(12, 12, self.frame.width - 24, 8 * 16))
        textField.textColor = NSColor.white
        textField.isEnabled = false
        textField.isSelectable = false
        textField.backgroundColor = NSColor.init(white: 0.1, alpha: 0.45)
        textField.drawsBackground = false;
        textField.alignment = NSTextAlignment.center
        textField.isBordered = false
        
        self.contentView?.addSubview(textField)
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
    
    private func sizeBezelBackground(radius: CGFloat, alpha: CGFloat, bgSize: NSSize) -> NSColor {
        let bgImage: NSImage = NSImage.init(size: bgSize)
        bgImage.lockFocus()
        
        let dummyRect = NSRect(x: 0, y: 0, width: bgSize.width-radius, height: bgSize.height-radius)
        let roundedRec = NSBezierPath().getBeizerPath(aRect: dummyRect, radius: radius)
        NSColor.init(white: 0.2, alpha: alpha).set()
        roundedRec.fill()
        bgImage.unlockFocus()
        return NSColor.init(patternImage: bgImage)
    }
    
    public func adjustWindowToCenter() {
        let scrrenFrame: CGRect = NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let originFrame = NSPoint(x: (scrrenFrame.size.width - NSWidth(self.frame)) * 0.5 + scrrenFrame.origin.x, y: (scrrenFrame.size.height - NSHeight(self.frame)) * 0.5 + scrrenFrame.origin.y)
        self.setFrameOrigin(originFrame)
    }
}


extension NSBezierPath {
    public func getBeizerPath(aRect: NSRect, radius: CGFloat) -> NSBezierPath {
        let path: NSBezierPath = NSBezierPath()
        
        let nowRadius = min(radius, CGFloat(0.5 * min(aRect.width, aRect.height)))
        let nowRect = NSInsetRect(aRect, CGFloat(radius), radius)
        
        path.appendArc(withCenter: NSPoint(x: NSMinX(nowRect), y: NSMinY(nowRect)), radius: nowRadius, startAngle: 180.0, endAngle: 270.0)
        path.appendArc(withCenter: NSPoint(x: NSMaxX(nowRect), y: NSMinY(nowRect)), radius: nowRadius, startAngle: 270.0, endAngle: 360.0)
        path.appendArc(withCenter: NSPoint(x: NSMaxX(nowRect), y: NSMaxY(nowRect)), radius: nowRadius, startAngle: 0.0, endAngle: 90.0)
        path.appendArc(withCenter: NSPoint(x: NSMinX(nowRect), y: NSMaxY(nowRect)), radius: nowRadius, startAngle: 90.0, endAngle: 180.0)
        
        path.close()
        return path;
    }
}
