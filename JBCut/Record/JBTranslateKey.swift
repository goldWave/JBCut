//
//  JBTranslateKey.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/16.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon

class JBTranslateKey: NSObject {
   static public func getSpecialCodeString(by keyCode: UInt16) -> String {
        //to tranlate the special keycode, the other key will get by 'charactersIgnoringModifiers' method, even if empty
        switch Int(keyCode) {
        case kVK_F1:  return "F1"
        case kVK_F2:  return "F2"
        case kVK_F3:  return "F3"
        case kVK_F4:  return "F4"
        case kVK_F5:  return "F5"
        case kVK_F6:  return "F6"
        case kVK_F7:  return "F7"
        case kVK_F8:  return "F8"
        case kVK_F9:  return "F9"
        case kVK_F10:  return "F10"
        case kVK_F11:  return "F11"
        case kVK_F12:  return "F12"
        case kVK_F13:  return "F13"
        case kVK_F14:  return "F14"
        case kVK_F15:  return "F15"
        case kVK_F16:  return "F16"
        case kVK_F17:  return "F17"
        case kVK_F18:  return "F18"
        case kVK_F19:  return "F19"
        case kVK_F20:  return "F20"
        case kVK_Space: return "Space"
        case kVK_ANSI_Quote: return "'"
        case kVK_ANSI_Semicolon: return ";"
        case kVK_ANSI_Backslash: return "\\"
        case kVK_ANSI_Comma: return ","
        case kVK_ANSI_Slash: return "/"
        case kVK_ANSI_Period: return "."
        case kVK_ANSI_Grave: return "`"
        case kVK_ANSI_Equal: return "="
        case kVK_ANSI_Minus: return "-"
        case kVK_ANSI_RightBracket: return "]"
        case kVK_ANSI_LeftBracket: return "["
        case kVK_ANSI_KeypadDecimal: return "."
        case kVK_ANSI_KeypadMultiply: return "*"
        case kVK_ANSI_KeypadPlus: return "+"
        case kVK_ANSI_KeypadMinus: return "-"
        case kVK_ANSI_KeypadEquals: return "="
        case kVK_ANSI_KeypadDivide: return "/"
        case kVK_ANSI_KeypadClear: return specialString(from: 0x2327)   // ⌧
        case kVK_ANSI_KeypadEnter: return specialString(from: 0x2305)   // ⌅
        case kVK_Return: return specialString(from: 0x21A9)             // ↩
        case kVK_Tab: return specialString(from: 0x21E5)                // ⇥
        case kVK_Delete: return specialString(from: 0x232B)             // ⌫
        case kVK_Escape:  return specialString(from: 0x238B)            // ⎋
        case kVK_Help:  return specialString(from: 0x003F)              // ?
        case kVK_Home:  return specialString(from: 0x2196)              // ↖
        case kVK_PageUp:  return specialString(from: 0x21DE)            // ⇞
        case kVK_ForwardDelete:  return specialString(from: 0x2326)     // ⌦
        case kVK_End:  return specialString(from: 0x2198)               // ↘
        case kVK_PageDown:  return specialString(from: 0x21DF)          // ⇟
        case kVK_LeftArrow:  return specialString(from: 0x2190)         // ←
        case kVK_RightArrow:  return specialString(from: 0x2192)        // →
        case kVK_DownArrow:  return specialString(from: 0x2193)         // ↓
        case kVK_UpArrow:  return specialString(from: 0x2191)           // ↑
        default:  return ""
        }
    }
    
    /*
     the NSEvent.ModifierFlags.command != cmdKey
     for example:
     NSEvent.ModifierFlags.command.rawValue = 1048576
     cmdkey = 256
     */
    static public func corbonModierValue(from modifierFlags: NSEvent.ModifierFlags) -> Int {
        var corbonValue = 0
        if modifierFlags.contains(.control) {
            corbonValue += controlKey
        }
        if modifierFlags.contains(.option) {
            corbonValue += optionKey
        }
        if modifierFlags.contains(.shift) {
            corbonValue += shiftKey
        }
        if modifierFlags.contains(.command) {
            corbonValue += cmdKey
        }
        return corbonValue
    }
    
    static public func getModifyString(from modifierFlags: NSEvent.ModifierFlags) -> String {
        var str = ""
        //        ["⇧", "⌃", "⌥", "⌘"]
        if modifierFlags.contains(.control) {
            str += "⌃"
        }
        if modifierFlags.contains(.option) {
            str += "⌥"
        }
        if modifierFlags.contains(.shift) {
            str += "⇧"
        }
        if modifierFlags.contains(.command) {
            str += "⌘"
        }
        
        return str
    }
    
    static private func specialString(from char: unichar) -> String {
        return String(format: "%C", char)
    }
}


