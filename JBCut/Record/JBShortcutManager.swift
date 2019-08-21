//
//  JBShortcutManager.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon

public struct JBShortKey: Codable {

    //which is corbon modifyFlags
    public var modifyFlags: Int
    
    public var modifyFlagsString: String
    
    public var keyCode: Int
    
    public var keyCodeStrig: String
    
    public init() {
        self.modifyFlags = 0
        self.modifyFlagsString = ""
        self.keyCode = 0
        self.keyCodeStrig = ""
    }
    
    public init(modifyFlags: Int, modifyFlagsString: String, keyCode: Int, keyCodeStrig: String) {
        self.modifyFlags = modifyFlags
        self.modifyFlagsString = modifyFlagsString
        self.keyCode = keyCode
        self.keyCodeStrig = keyCodeStrig
    }
}

class JBShortcutManager: NSObject {
    public static let manager = JBShortcutManager()
    public var pressModifierFlags = NSEvent.ModifierFlags.init(rawValue: 0)
    public var pressKeyCode: UInt16 = 0
    public var keyCodeString = ""
    public var modifierFlagsString = ""
    public var isValidKeyCode = false
    
    public var generateHotkey:JBShortKey {
        return JBShortKey.init(modifyFlags: JBTranslateKey.corbonModierValue(from: pressModifierFlags),
                               modifyFlagsString:modifierFlagsString,
                               keyCode: Int(pressKeyCode),
                               keyCodeStrig: keyCodeString)
    }
    
    public func praseEvent(keyEvent: NSEvent) {
        pressKeyCode = keyEvent.keyCode
        keyCodeString = getString(with: keyEvent)
        pressModifierFlags = keyEvent.modifierFlags;
        print("mouse up flag: code:", keyEvent.modifierFlags.rawValue,  keyEvent.keyCode)
        modifierFlagsString = JBTranslateKey.getModifyString(from: pressModifierFlags)
        isValidKeyCode = !(modifierFlagsString.isEmpty || (modifierFlagsString.isEmpty && pressKeyCode == kVK_Escape))
    }
    
    public func getString(with keyEvent: NSEvent) -> String {
        
        var keyString = JBTranslateKey.getSpecialCodeString(by: keyEvent.keyCode)
        if keyString == "" {
            keyString = keyEvent.charactersIgnoringModifiers?.uppercased() ?? ""
        }
        return keyString
    }
    
    public func clearTempData() {
        pressModifierFlags = NSEvent.ModifierFlags.init(rawValue: 0)
        pressKeyCode = 0
        keyCodeString = ""
        modifierFlagsString = ""
        isValidKeyCode = false
    }
}
