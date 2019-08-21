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
    let nextHotkeyId = EventHotKeyID(signature: FourCharCode.init(stringLiteral: "NXHK"), id: 1)
    let preHotkeyId = EventHotKeyID(signature: FourCharCode.init(stringLiteral: "PRHk"), id: 2)
    
    var nextHotkey: EventHotKeyRef? = nil
    var preHotkey: EventHotKeyRef? = nil
    
    public func handleHotKeyEvent() {
        
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (nextHander, theEvent, userData) -> OSStatus in
            var hotkeyID = EventHotKeyID()
            print("handleHotKeyEvent")
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
        
//        registerHotkey();
    }
    
    private func unRegisterHotkey() {
        UnregisterEventHotKey(preHotkey)
        UnregisterEventHotKey(nextHotkey)
    }
    
    public func registerHotkey() {
        
        unRegisterHotkey();
        
        print("register Pre keyCode: + \(GlobalVariable.shared.preShortKey)")
        print("register Next keyCode: + \(GlobalVariable.shared.nextShortKey)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if GlobalVariable.shared.preShortKey.keyCode > 0 {
                RegisterEventHotKey(UInt32(GlobalVariable.shared.preShortKey.keyCode), UInt32(GlobalVariable.shared.preShortKey.modifyFlags), self.preHotkeyId, GetApplicationEventTarget(), OptionBits(0), &self.preHotkey)
            }
            
            if GlobalVariable.shared.nextShortKey.keyCode > 0 {
                RegisterEventHotKey(UInt32(GlobalVariable.shared.nextShortKey.keyCode), UInt32(GlobalVariable.shared.nextShortKey.modifyFlags), self.nextHotkeyId, GetApplicationEventTarget(), OptionBits(0), &self.nextHotkey)
            }
        }
        handleHotKeyEvent()
    }
    
    func fakeCommandVWithDelay() {
        self.perform(#selector(fakeCommandV), with: nil, afterDelay: 0.2)
    }
    
    @objc private func fakeCommandV() {
        let source = CGEventSource(stateID: .combinedSessionState)
        //disabel local keyboard click
        source?.setLocalEventsFilterDuringSuppressionState([.permitLocalKeyboardEvents, .permitSystemDefinedEvents], state: .eventSuppressionStateSuppressionInterval)
        //press command + v
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        keyDown?.flags = .maskCommand
        //release command + v
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)
        keyUp?.flags = .maskCommand
        //post paste command
        keyDown?.post(tap: .cgAnnotatedSessionEventTap)
        keyUp?.post(tap: .cgAnnotatedSessionEventTap)
    }
}

extension FourCharCode: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        let value = (value.utf8.count == 4) ? value : "????"
        self = value.utf8.reduce(0, {$0 << 8 + FourCharCode($1)} )
    }
    
}
