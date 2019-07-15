//
//  HotKeyCenter.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/4.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon


protocol HotKeyDelegate {
    func hotKeyCliked(isNext: Bool)
}

class HotKeyCenter: NSObject {
    
    public static let shared = HotKeyCenter()
    var delegate : HotKeyDelegate?
    let nextHotkeyId = EventHotKeyID(signature: 1, id: 1)
    let preHotkeyId = EventHotKeyID(signature: 2, id: 2)
    
    public func registerHotKey() {
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (nextHander, theEvent, userData) -> OSStatus in
            var hotkeyID = EventHotKeyID()
            
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout.size(ofValue: EventHotKeyID()), nil, &hotkeyID)
            
            switch GetEventKind(theEvent) {
            case EventParamName(kEventHotKeyPressed):
                let isNext = HotKeyCenter.shared.nextHotkeyId.signature == hotkeyID.signature && HotKeyCenter.shared.nextHotkeyId.id == hotkeyID.id
                HotKeyCenter.shared.delegate?.hotKeyCliked(isNext: isNext)
            default:
                assert(false, "unknown event kind to click")
            }
            
            return noErr
        }, 1, &eventType, nil, nil)
        
        var hotkey: EventHotKeyRef? = nil
        
        RegisterEventHotKey(UInt32(kVK_ANSI_K), UInt32(cmdKey|shiftKey), preHotkeyId, GetApplicationEventTarget(), OptionBits(0), &hotkey)
        RegisterEventHotKey(UInt32(kVK_ANSI_L), UInt32(cmdKey|shiftKey), nextHotkeyId, GetApplicationEventTarget(), OptionBits(0), &hotkey)
    }
}
