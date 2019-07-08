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
    
    private var contentTextField: RoundRexTextfield!
    private var indexTextField: RoundRexTextfield!
    private var timeTextField: RoundRexTextfield!
    private var iconImageView: NSImageView!
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
        self.backgroundColor = sizeBezelBackground(radius: 25, alpha: 0.85, bgSize: NSSize(width: cusSzie.width, height: cusSzie.height))
        self.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
        
        setupSubView()
       
    }
    
    func setupSubView() {
        contentTextField = RoundRexTextfield.init(frame: NSMakeRect(12, 12, self.frame.width - 24, 8 * 16))
        contentTextField.textColor = NSColor.white
        contentTextField.isEnabled = false
        contentTextField.isSelectable = false
        contentTextField.backgroundColor = NSColor.init(white: 0.1, alpha: 0.45)
        contentTextField.drawsBackground = false;
        contentTextField.alignment = NSTextAlignment.center
        contentTextField.isBordered = false
        
        
        iconImageView = NSImageView.init(image: NSImage(named: "big_icon") ?? NSImage.init())
        iconImageView.frame = NSRect(x: 20, y: NSMaxY(contentTextField.frame) + 30, width: 70, height: 70)
        
        
        timeTextField = RoundRexTextfield.init(frame: NSMakeRect(NSMaxX(iconImageView.frame) + 20 , NSMaxY(iconImageView.frame) - 25, self.frame.width - NSMaxX(iconImageView.frame) - 2 * 20, 18))
        timeTextField.textColor = NSColor.white
        timeTextField.isEnabled = false
        timeTextField.isSelectable = false
        timeTextField.backgroundColor = NSColor.init(white: 0.1, alpha: 0.45)
        timeTextField.drawsBackground = false;
        timeTextField.alignment = NSTextAlignment.center
        timeTextField.isBordered = false
        timeTextField.stringValue = "2018-989-56"
        
        indexTextField = RoundRexTextfield.init(frame: NSMakeRect(NSMinX(timeTextField.frame) , NSMinY(timeTextField.frame) - 35, NSWidth(timeTextField.frame), NSHeight(timeTextField.frame)))
        indexTextField.textColor = NSColor.white
        indexTextField.isEnabled = false
        indexTextField.isSelectable = false
        indexTextField.backgroundColor = NSColor.init(white: 0.1, alpha: 0.45)
        indexTextField.drawsBackground = false;
        indexTextField.alignment = NSTextAlignment.center
        indexTextField.isBordered = false
        
        self.contentView?.addSubview(contentTextField)
        self.contentView?.addSubview(indexTextField)
        self.contentView?.addSubview(iconImageView)
        self.contentView?.addSubview(timeTextField)
    }
    
    public func setCurrentData(data: ClipData, indexString: String) {
        contentTextField.stringValue = data.clipString
        indexTextField.stringValue = indexString
        timeTextField.stringValue = data.timeStamp.timeFormateChange()
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
        
        let dummyRect = NSRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
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

extension Int {
    func timeFormateChange() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate = dateFormatter.string(from: date)
        return nowDate
    }
}
