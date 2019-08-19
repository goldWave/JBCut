//
//  JBShortcutManager.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

struct JBShortKey: Codable {

    public var modifyFlags: Int
    
    public var keyCode: Int
    
    public var keyCodeStrig: String
    
    public init() {
        self.modifyFlags = 0
        self.keyCode = 0
        self.keyCodeStrig = ""
    }
    
    public init(modifyFlags: Int, keyCode: Int, keyCodeStrig: String) {
        self.modifyFlags = modifyFlags
        self.keyCode = keyCode
        self.keyCodeStrig = keyCodeStrig
    }
}

class JBShortcutManager: NSObject {
    public static let manager = JBShortcutManager()
    public var pressModifierFlags = NSEvent.ModifierFlags.init(rawValue: 0)
    public var pressKeyCode: UInt16 = 0
    public var keyCodeString = "Press hot key"
    public var modifierFlagsString = ""
    public var isValidKeyCode = false
    
    public func praseEvent(keyEvent: NSEvent) -> Bool {
        keyCodeString = getString(with: keyEvent)
        pressKeyCode = keyEvent.keyCode
        pressModifierFlags = keyEvent.modifierFlags;
        print("mouse up flag: code:", keyEvent.modifierFlags.rawValue,  keyEvent.keyCode)
        modifierFlagsString = JBTranslateKey.getModifyString(from: pressModifierFlags)
        isValidKeyCode = true
        return true;
    }
    
    public func getString(with keyEvent: NSEvent) -> String {
        
        var keyString = JBTranslateKey.getSpecialCodeString(by: keyEvent.keyCode)
        if keyString == "" {
            keyString = keyEvent.charactersIgnoringModifiers?.uppercased() ?? ""
        }
        return keyString
    }
}
