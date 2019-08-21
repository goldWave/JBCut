//
//  JBRecordView.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

protocol RecordViewDelegate: class {
    func recordViewDidBeginRecord(_ recordView: JBRecordView);
    func recordViewDidFinishRecord(_ recordView: JBRecordView, _ isVaildKey: Bool, _ keyStruct: JBShortKey);
}

class JBRecordView: NSView {
    
    public weak var delegate: RecordViewDelegate?
    private var isRecording: Bool = false
    public var hotKey:JBShortKey = JBShortKey.init()
    private let cornerRadius: CGFloat = 10
    
    override func draw(_ dirtyRect: NSRect) {
        self.wantsLayer = true
        drawBorder()
        drawKeyText()
    }
    
    override func keyDown(with event: NSEvent) {
        print("keyDown")
        super.keyDown(with: event)
        JBShortcutManager.manager.praseEvent(keyEvent: event)
        print("keyDown return")
        self.window?.makeFirstResponder(nil)
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        print("mouseUp")
    }
    
    override func becomeFirstResponder() -> Bool {
        print("becomeFirstResponder")
        self.isRecording = true
        JBShortcutManager.manager.clearTempData()
        needsDisplay = true
        self.delegate?.recordViewDidBeginRecord(self)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        print("resignFirstResponder")
        self.isRecording = false
        
        self.delegate?.recordViewDidFinishRecord(self,
                                                 JBShortcutManager.manager.isValidKeyCode,
                                                 JBShortcutManager.manager.generateHotkey)
        
        if JBShortcutManager.manager.isValidKeyCode {
            hotKey = JBShortcutManager.manager.generateHotkey
        }
         needsDisplay = true
        
        return super.resignFirstResponder()
    }
    
    func drawKeyText() {
        
        var totalString: String = hotKey.modifyFlagsString + hotKey.keyCodeStrig
        let emptyText: Bool =  (self.isRecording || totalString.isEmpty)
        if  emptyText {
            totalString = "Press key to record shorcut"
        }
        
        let attributeDict: [NSAttributedString.Key : Any] = [
            .font: emptyText ? NSFont.systemFont(ofSize: 14) : NSFont.boldSystemFont(ofSize: 15),
            .foregroundColor: NSColor.textColor,
            .kern: emptyText ? 0 : 2
        ]

        let textSize = totalString.size(withAttributes: attributeDict)
        totalString.draw(in: NSRect(x: 10, y: (bounds.height - textSize.height) * 0.5 , width: textSize.width, height: textSize.height), withAttributes: attributeDict)
    }
    
    func drawBorder() {
        self.layer?.backgroundColor = NSColor.controlColor.cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = cornerRadius
        if #available(OSX 10.14, *) {
            self.layer?.borderColor = NSColor.separatorColor.cgColor
        } else {
             self.layer?.borderColor = NSColor.lightGray.withAlphaComponent(0.6).cgColor
        }
    }

    override func setAccessibilityClearButton(_ accessibilityClearButton: Any?) {
        
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    override var canBecomeKeyView: Bool {
        return true
    }
    
    override func drawFocusRingMask() {
        NSBezierPath(roundedRect: bounds, xRadius: cornerRadius, yRadius: cornerRadius).fill()
    }
    
    override var focusRingMaskBounds: NSRect {
        return bounds;
    }
}
