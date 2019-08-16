//
//  LoginItem.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/14.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import ServiceManagement

class LoginItem: NSObject {
    static func checkAppStartWithLoginItem() {
        if SMLoginItemSetEnabled("com.jimbo.JBCut-Helper" as CFString, (GlobalVariable.shared.launchAtLogin as NSNumber).boolValue) {
            print("add to login item succeed")
        } else {
            print("add to login item succeed")
        }
    }
}
