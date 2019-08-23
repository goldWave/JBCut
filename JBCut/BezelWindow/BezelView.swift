//
//  BezelView.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/22.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class BezelView: NSView {

    
    private var contentTextField: RoundRexTextfield!
    private var indexTextField: RoundRexTextfield!
    private var timeTextField: RoundRexTextfield!
    private var iconImageView: NSImageView!
    private var data: ClipData = ClipData.init()
    private let leadingConstant: CGFloat = 20
    private let contentTextBottomConstant: CGFloat = 12
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupUI()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    func setupUI() {
        self.wantsLayer = true;
        self.layer?.backgroundColor = sizeBezelBackground(radius: 25, bgSize: NSSize(width: self.bounds.width, height: self.bounds.height)).cgColor
        self.layer?.cornerRadius = 25
//        self.shadow = NSShadow()
//        self.layer?.cornerRadius = 5.0
//        self.layer?.shadowOpacity = 1.0
//        self.layer?.shadowColor = NSColor.systemGray.cgColor
//        self.layer?.shadowOffset = NSMakeSize(0, 0)
//        self.layer?.shadowRadius = 20
        self.setupSubView()
    }
    
    private func setupSubView() {
        contentTextField = RoundRexTextfield.init(frame: NSMakeRect(leadingConstant, contentTextBottomConstant, self.frame.width - leadingConstant * 2, 8 * 16))
        contentTextField.textColor = NSColor.white
        contentTextField.isEnabled = false
        contentTextField.isSelectable = false
        contentTextField.backgroundColor = GlobalVariable.shared.textBgColor
        contentTextField.drawsBackground = false;
        contentTextField.alignment = NSTextAlignment.center
        contentTextField.isBordered = false
        
        iconImageView = NSImageView.init(image: NSImage(named: "big_icon") ?? NSImage.init())
        iconImageView.frame = NSRect(x: leadingConstant, y: NSMaxY(contentTextField.frame) + 30, width: 70, height: 70)
        iconImageView.imageScaling = .scaleProportionallyUpOrDown
        
        timeTextField = RoundRexTextfield.init(frame: NSMakeRect(NSMaxX(iconImageView.frame) + leadingConstant , NSMaxY(iconImageView.frame) - 25, self.frame.width - NSMaxX(iconImageView.frame) - 2 * leadingConstant, 18))
        timeTextField.textColor = NSColor.white
        timeTextField.isEnabled = false
        timeTextField.isSelectable = false
        timeTextField.backgroundColor = GlobalVariable.shared.textBgColor
        timeTextField.drawsBackground = false;
        timeTextField.alignment = NSTextAlignment.center
        timeTextField.isBordered = false
        timeTextField.stringValue = "2018-989-56"
        
        indexTextField = RoundRexTextfield.init(frame: NSMakeRect(NSMinX(timeTextField.frame) , NSMinY(timeTextField.frame) - 35, NSWidth(timeTextField.frame), NSHeight(timeTextField.frame)))
        indexTextField.textColor = NSColor.white
        indexTextField.isEnabled = false
        indexTextField.isSelectable = false
        indexTextField.backgroundColor = GlobalVariable.shared.textBgColor
        indexTextField.drawsBackground = false;
        indexTextField.alignment = NSTextAlignment.center
        indexTextField.isBordered = false
        
        self.addSubview(contentTextField)
        self.addSubview(indexTextField)
        self.addSubview(iconImageView)
        self.addSubview(timeTextField)
        
        reassembleSubView()
    }
    
    public func reassembleSubView() {
        self.timeTextField.isHidden = GlobalVariable.shared.showClipTime == NSControl.StateValue.off.rawValue
        self.indexTextField.isHidden = GlobalVariable.shared.showClipIndex == NSControl.StateValue.off.rawValue
        self.iconImageView.isHidden = GlobalVariable.shared.showClipIcon == 2
        iconImageView.image = GlobalVariable.shared.showClipIcon == 0 ? NSImage(named: "big_icon") : NSWorkspace.shared.icon(forFile: data.appIconPath)
        
        //icon frame
        var iconPoint = self.iconImageView.frame.origin
        iconPoint.x = (self.timeTextField.isHidden && self.indexTextField.isHidden) ? (self.bounds.width - self.iconImageView.bounds.width) * 0.5 : leadingConstant
        self.iconImageView.setFrameOrigin(iconPoint)
        
        //time frame
        var timeRect = self.timeTextField.frame
        timeRect.origin.x = self.iconImageView.isHidden ? leadingConstant : (NSMaxX(iconImageView.frame) + leadingConstant)
        timeRect.origin.y = (!self.iconImageView.isHidden && self.indexTextField.isHidden) ? (NSMinY(iconImageView.frame) + 0.5 * iconImageView.bounds.height - 0.5 * timeRect.size.height) : NSMaxY(iconImageView.frame) - 25
        timeRect.size.width = self.iconImageView.isHidden ? (self.bounds.width - 2 * leadingConstant) : (self.frame.width - NSMaxX(iconImageView.frame) - 2 * leadingConstant)
        self.timeTextField.frame = timeRect

        //index frame
        var indexRect = self.indexTextField.frame
        indexRect.origin.x = timeRect.origin.x
        indexRect.size.width = timeRect.size.width
        if self.iconImageView.isHidden && self.timeTextField.isHidden {
            indexRect.origin.y =  NSMaxY(iconImageView.frame) - 25
        } else if (!self.iconImageView.isHidden && self.timeTextField.isHidden) {
           indexRect.origin.y = (NSMinY(iconImageView.frame) + 0.5 * iconImageView.bounds.height -  0.5 * indexRect.size.height)
        } else {
            indexRect.origin.y = (NSMinY(timeRect) - 35)
        }
        self.indexTextField.frame = indexRect
        
        //content frame
        var contentSize = self.contentTextField.frame.size
        if self.timeTextField.isHidden && self.indexTextField.isHidden && self.iconImageView.isHidden {
            contentSize.height = self.bounds.height - 2 * contentTextBottomConstant
        } else if (self.timeTextField.isHidden || self.indexTextField.isHidden) && self.iconImageView.isHidden {
            contentSize.height = self.bounds.height - contentTextBottomConstant - 100
        } else {
            contentSize.height = 8 * 16
        }
        self.contentTextField.setFrameSize(contentSize)
    }
    
    public func changeBgColor() {
        self.layer?.backgroundColor = sizeBezelBackground(radius: 25, bgSize: NSSize(width: self.bounds.width, height: self.bounds.height)).cgColor
        self.indexTextField.backgroundColor = GlobalVariable.shared.textBgColor
        self.timeTextField.backgroundColor = GlobalVariable.shared.textBgColor
        self.contentTextField.backgroundColor = GlobalVariable.shared.textBgColor
        needsDisplay = true
    }
    
    public func setCurrentData(data: ClipData, indexString: String) {
        self.data = data
        contentTextField.stringValue = data.clipString
        indexTextField.stringValue = indexString
        timeTextField.stringValue = data.timeStamp.timeFormateChange()
        iconImageView.image = GlobalVariable.shared.showClipIcon == 0 ? NSImage(named: "big_icon") : NSWorkspace.shared.icon(forFile: data.appIconPath)
    }
    
    private func sizeBezelBackground(radius: CGFloat, bgSize: NSSize) -> NSColor {
        let bgImage: NSImage = NSImage.init(size: bgSize)
        bgImage.lockFocus()
        
        let dummyRect = NSRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
        let roundedRec = NSBezierPath().getBeizerPath(aRect: dummyRect, radius: radius)
        GlobalVariable.shared.winBgColor.set()
        roundedRec.fill()
        bgImage.unlockFocus()
        return NSColor.init(patternImage: bgImage)
    }
}
