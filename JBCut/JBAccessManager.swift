//
//  JBAccessManager.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/23.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class JBAccessManager: NSObject {
    
    static func checkAccessibility() -> Bool {
        //since macOS 10.14 Mojave need accessibility permission to type command v
        if #available(macOS 10.14, *) {
            let checkOptionPromptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
            //true means it will popup and ask
            let options = [checkOptionPromptKey: true] as CFDictionary
            return AXIsProcessTrustedWithOptions(options)
        }
        return true
    }
}
