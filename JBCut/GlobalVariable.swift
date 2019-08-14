//
//  GlobalVariable.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/12.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

struct JBConstants {
    static let clipMenuCount: String = "clipMenuCount";
    static let displayMenuCount: String = "displayMenuCount";
    static let displayLength: String = "displayLength";
    static let launchAtLogin: String = "launchAtLogin";
    static let showHistory: String = "showHistory";
    static let selectPastes: String = "selectPastes";
    static let saveTime: String = "saveTime";
    struct Notification {
       static let clipMenuCountChanged: String = "clipMenuCountChanged";
    }
}


@objcMembers class GlobalVariable: NSObject {
    
    public static let shared = GlobalVariable()
    
    var clipMenuCount: Int = 20
    var displayMenuCount: Int = 10
    var displayLength: Int = 40
    
    var launchAtLogin: Int = NSControl.StateValue.off.rawValue;
    var menuShowHistory: Int = NSControl.StateValue.on.rawValue;
    var menuSelectPastes: Int = NSControl.StateValue.on.rawValue;
    var saveTime: Int = 0;

    func readDataFronUserDefault() {
        clipMenuCount = UserDefaults.standard.getIntValue(key: JBConstants.clipMenuCount, defaultValue: clipMenuCount)
        displayMenuCount = UserDefaults.standard.getIntValue(key: JBConstants.displayLength, defaultValue: displayMenuCount)
        displayLength = UserDefaults.standard.getIntValue(key: JBConstants.displayLength, defaultValue: displayLength)
        
        launchAtLogin = UserDefaults.standard.getIntValue(key: JBConstants.launchAtLogin, defaultValue: launchAtLogin)
        menuShowHistory = UserDefaults.standard.getIntValue(key: JBConstants.showHistory, defaultValue: menuShowHistory)
        menuSelectPastes = UserDefaults.standard.getIntValue(key: JBConstants.selectPastes, defaultValue: menuSelectPastes)
        
        saveTime = UserDefaults.standard.getIntValue(key: JBConstants.saveTime, defaultValue: saveTime)
    }
}

extension UserDefaults {
    
    func hasValue(forKey key: String) -> Bool {
        return nil != object(forKey: key)
    }
    
    func getIntValue(key: String, defaultValue: Int) -> Int {
        if self.hasValue(forKey: key) {
            return self.integer(forKey: key)
        } else {
            return defaultValue
        }
    }
    
    func getBoolValue(key: String, defaultValue: Bool) -> Bool {
        if self.hasValue(forKey: key) {
            return self.bool(forKey: key)
        } else {
            return defaultValue
        }
    }
}
