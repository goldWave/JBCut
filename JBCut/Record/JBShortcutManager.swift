//
//  JBShortcutManager.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/15.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon

class JBShortcutManager: NSObject {
    public static let manager = JBShortcutManager()
    public var pressModifierFlags = NSEvent.ModifierFlags.init(rawValue: 0)
    public var pressKeyCode: UInt16 = 0
    public var keyCodeString = "Press hot key"
    public var modifierFlagsString = ""
    
    public func praseEvent(keyEvent: NSEvent) -> Bool {
        pressKeyCode = keyEvent.keyCode
        pressModifierFlags = keyEvent.modifierFlags;
        print("mouse up flag:   code:", keyEvent.modifierFlags.rawValue,  keyEvent.keyCode)
        modifierFlagsString = getModifyString()
        keyCodeString = getString(with: keyEvent)
        return true;
    }
    
    
    public func getString(with keyEvent: NSEvent) -> String {
        var keyString = ""
        //        if keyEvent.specialKey != nil {
        //            print("contain special key")
        //            switch keyEvent.specialKey! {
        //            case .upArrow:
        //                keyString = ""
        //            case .upArrow:
        //                keyString = ""
        //            default:
        //                print("")
        //            }
        //
        //        }
        
        keyString = getCodeString(by: keyEvent.keyCode)
        if keyString == "" {
           keyString = keyEvent.charactersIgnoringModifiers?.uppercased() ?? ""
        }
//        var MChar = keyEvent.characters ?? ""
//        var char = keyEvent.charactersIgnoringModifiers ?? ""
//        print("--------------")
//        print(char)
//        print(MChar)
//        print("--------------")
//        char = char.uppercased()
        return keyString
    }
    
    
    func getCodeString(by keyCode: UInt16) -> String {
        var nowString = ""
        
        switch Int(keyCode) {
        case kVK_Return:
            nowString = "kVK_Return"
        case kVK_Tab:
            nowString = "kVK_Tab"
        case kVK_Space:
            nowString = "kVK_Space"
        case kVK_Delete:
            nowString = "kVK_Delete"
        case kVK_Escape:
            nowString = "kVK_Escape"
        case kVK_Command:
            nowString = "kVK_Command"
        case kVK_Shift:
            nowString = "kVK_Shift"
        case kVK_CapsLock:
            nowString = "kVK_CapsLock"
        case kVK_Option:
            nowString = "kVK_Option"
        case kVK_Control:
            nowString = "kVK_Control"
        case kVK_RightCommand:
            nowString = ""
        case kVK_RightShift:
            nowString = ""
        case kVK_RightOption:
            nowString = ""
        case kVK_RightControl:
            nowString = ""
        case kVK_Function:
            nowString = "kVK_Function"
        case kVK_F17:
            nowString = "kVK_F17"
        case kVK_VolumeUp:
            nowString = "kVK_VolumeUp"
        case kVK_VolumeDown:
            nowString = "kVK_VolumeDown"
        case kVK_Mute:
            nowString = "kVK_Mute"
        case kVK_F18:
            nowString = "kVK_F18"
        case kVK_F19:
            nowString = "kVK_F19"
        case kVK_F20:
            nowString = "kVK_F20"
        case kVK_F5:
            nowString = "kVK_F5"
        case kVK_F6:
            nowString = "kVK_F6"
        case kVK_F7:
            nowString = "kVK_F7"
        case kVK_F3:
            nowString = "kVK_F3"
        case kVK_F8:
            nowString = "kVK_F8"
        case kVK_F9:
            nowString = "kVK_F9"
        case kVK_F11:
            nowString = "kVK_F11"
        case kVK_F13:
            nowString = "kVK_F13"
        case kVK_F16:
            nowString = "kVK_F16"
        case kVK_F14:
            nowString = "kVK_F14"
        case kVK_F10:
            nowString = "kVK_F10"
        case kVK_F12:
            nowString = "kVK_F12"
        case kVK_F15:
            nowString = "kVK_F15"
        case kVK_Help:
            nowString = "kVK_Help"
        case kVK_Home:
            nowString = "kVK_Home"
        case kVK_PageUp:
            nowString = "kVK_PageUp"
        case kVK_ForwardDelete:
            nowString = "kVK_ForwardDelete"
        case kVK_F4:
            nowString = "kVK_F4"
        case kVK_End:
            nowString = "kVK_End"
        case kVK_F2:
            nowString = "kVK_F2"
        case kVK_PageDown:
            nowString = "kVK_PageDown"
        case kVK_F1:
            nowString = "kVK_F1"
        case kVK_LeftArrow:
            nowString = "kVK_LeftArrow"
        case kVK_RightArrow:
            nowString = "kVK_RightArrow"
        case kVK_DownArrow:
            nowString = "kVK_DownArrow"
        case kVK_UpArrow:
            nowString = "kVK_UpArrow"
        default:
            nowString = ""
            
        }
        return nowString
    }
    
    private func getModifyString() -> String {
        var str = ""
        //        ["⇧", "⌃", "⌥", "⌘"]
        if pressModifierFlags.contains(.control) {
            str = str + "⌃"
        }
        
        if pressModifierFlags.contains(.option) {
            str = str + "⌥"
        }
        
        if pressModifierFlags.contains(.shift) {
            str = str + "⇧"
        }
        
        if pressModifierFlags.contains(.command) {
            str = str + "⌘"
        }
        
        return str
    }
}
