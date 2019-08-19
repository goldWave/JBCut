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
    
    public weak var delegate : RecordViewDelegate?
    public var isRecording: Bool = false
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        self.wantsLayer = true
        drawKeyText()
    }
    
    override func keyDown(with event: NSEvent) {
        print("keyDown")
        super.keyDown(with: event)
        if JBShortcutManager.manager.praseEvent(keyEvent: event) {
            self.window?.makeFirstResponder(nil)
            needsDisplay = true
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        print("mouseUp")
    }
    
    override func becomeFirstResponder() -> Bool {
        print("becomeFirstResponder")
        self.isRecording = true
        needsDisplay = true
        self.delegate?.recordViewDidBeginRecord(self)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        print("resignFirstResponder")
        self.isRecording = false
        needsDisplay = true
        
        self.delegate?.recordViewDidFinishRecord(self,
                                                 JBShortcutManager.manager.isValidKeyCode,
                                                 JBShortKey.init(modifyFlags: JBTranslateKey.corbonModierValue(from: JBShortcutManager.manager.pressModifierFlags),
                                                                 keyCode: Int(JBShortcutManager.manager.pressKeyCode),
                                                                 keyCodeStrig: JBShortcutManager.manager.keyCodeString))
        
        return super.resignFirstResponder()
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
        drawBorder(self.isRecording)
    }
    
    func drawBorder(_ needDraw: Bool) {
        self.layer?.borderWidth = 2
        self.layer?.cornerRadius = 5
        self.layer?.borderColor = needDraw ? NSColor.orange.cgColor : NSColor.clear.cgColor
    }
}
