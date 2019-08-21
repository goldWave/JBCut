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

    lazy var clearButton: NSButton = {
        () -> NSButton in
        let buttonWidth: CGFloat = 20
        let buttonHeight: CGFloat = 20
        
        let clearButton: NSButton = NSButton(frame: NSRect(x: self.bounds.width - buttonWidth - 5 , y: (self.bounds.height - buttonHeight) * 0.5 , width: buttonWidth, height: buttonHeight))
        clearButton.image = NSImage.init(named: "clear_dark")
        clearButton.bezelStyle = .regularSquare
        clearButton.imagePosition = .imageOnly
        clearButton.imageScaling = .scaleNone
        clearButton.target = self
        clearButton.action = #selector(clearButtonClick)
        clearButton.setButtonType(NSButton.ButtonType.momentaryPushIn)
        clearButton.isBordered = false
        clearButton.isHidden = true
        self.addSubview(clearButton)
        
        return clearButton
    }()

    override func draw(_ dirtyRect: NSRect) {
        self.wantsLayer = true
        drawBorder()
        drawKeyText()

        self.clearButton.image = NSImage.init(named: isDarkTheme() ? "clear_dark" : "clear_light")
        self.clearButton.isHidden = self.isRecording
    }
    
    func isDarkTheme() -> Bool {
        let appearance = NSAppearance.current
        if #available(OSX 10.14, *)  {
          return appearance?.name == NSAppearance.Name.darkAqua;
        }
        return false
    }
    
    @objc func clearButtonClick() {
        JBShortcutManager.manager.clearTempData()
        JBShortcutManager.manager.isValidKeyCode = true
        sendRecordData()
        needsDisplay = true
    }
    
    override func keyDown(with event: NSEvent) {
        print("keyDown")
        super.keyDown(with: event)
        JBShortcutManager.manager.praseEvent(keyEvent: event)
        self.window?.makeFirstResponder(nil)
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
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
        sendRecordData()
        needsDisplay = true
        return super.resignFirstResponder()
    }
    
    func sendRecordData() {
        self.delegate?.recordViewDidFinishRecord(self,
                                                 JBShortcutManager.manager.isValidKeyCode,
                                                 JBShortcutManager.manager.generateHotkey)
        
        if JBShortcutManager.manager.isValidKeyCode {
            hotKey = JBShortcutManager.manager.generateHotkey
        }
    }
    
    func drawKeyText() {
        
        var totalString: String = hotKey.modifyFlagsString + hotKey.keyCodeStrig
        
        let emptyText: Bool =  (self.isRecording || totalString.isEmpty)

        if  self.isRecording {
            totalString = "Press key to record"
        } else if totalString.isEmpty {
            totalString = "Click to record"
        }

        let attributeDict: [NSAttributedString.Key : Any] = [
            .font: emptyText ? NSFont.systemFont(ofSize: 13) : NSFont.boldSystemFont(ofSize: 15),
            .foregroundColor: emptyText ? NSColor.placeholderTextColor : NSColor.textColor,
            .kern: emptyText ? 0 : 2
        ]

        let textSize = totalString.size(withAttributes: attributeDict)
        totalString.draw(in: NSRect(x: 10, y: (bounds.height - textSize.height) * 0.5 , width: textSize.width, height: textSize.height), withAttributes: attributeDict)
    }
    
    func drawBorder() {
        self.layer?.backgroundColor = NSColor.init(hexString: isDarkTheme() ? "#3B3C3E" : "#FFFFFF").cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = cornerRadius
        if #available(OSX 10.14, *) {
            self.layer?.borderColor = NSColor.separatorColor.cgColor
        } else {
             self.layer?.borderColor = NSColor.lightGray.withAlphaComponent(0.6).cgColor
        }
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
