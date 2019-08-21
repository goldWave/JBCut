//
//  GlobalVariable.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/12.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa
import Carbon

struct JBConstants {
    
    static let generalIdentidier: String = "GeneralViewController";
    static let hotkeysIdentidier: String = "HotkeysViewController";
    static let appearanceIdentidier: String = "AppearanceViewController";
    
    static let clipMenuCount: String = "clipMenuCount";
    static let displayMenuCount: String = "displayMenuCount";
    static let displayLength: String = "displayLength";
    static let launchAtLogin: String = "launchAtLogin";
    static let showHistory: String = "showHistory";
    static let selectPastes: String = "selectPastes";
    static let saveTime: String = "saveTime";
    static let preShortKey: String = "preShortKey";
    static let nextShortKey: String = "nextShortKey";
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
    
    var preShortKey: JBShortKey = JBShortKey(modifyFlags: cmdKey|shiftKey, modifyFlagsString: "⇧⌘", keyCode: kVK_ANSI_K, keyCodeStrig: "K");
    var nextShortKey: JBShortKey = JBShortKey(modifyFlags: cmdKey|shiftKey, modifyFlagsString: "⇧⌘", keyCode: kVK_ANSI_L, keyCodeStrig: "L");

    private override init() {
        super.init()
        self.readDataFronUserDefault()
    }
    
    func readDataFronUserDefault() {
        clipMenuCount = UserDefaults.standard.getIntValue(key: JBConstants.clipMenuCount, defaultValue: clipMenuCount)
        displayMenuCount = UserDefaults.standard.getIntValue(key: JBConstants.displayLength, defaultValue: displayMenuCount)
        displayLength = UserDefaults.standard.getIntValue(key: JBConstants.displayLength, defaultValue: displayLength)
        
        launchAtLogin = UserDefaults.standard.getIntValue(key: JBConstants.launchAtLogin, defaultValue: launchAtLogin)
        menuShowHistory = UserDefaults.standard.getIntValue(key: JBConstants.showHistory, defaultValue: menuShowHistory)
        menuSelectPastes = UserDefaults.standard.getIntValue(key: JBConstants.selectPastes, defaultValue: menuSelectPastes)
        
        saveTime = UserDefaults.standard.getIntValue(key: JBConstants.saveTime, defaultValue: saveTime)
        
        preShortKey = UserDefaults.standard.structData(JBShortKey.self, forKey: JBConstants.preShortKey) ?? preShortKey
        nextShortKey = UserDefaults.standard.structData(JBShortKey.self, forKey: JBConstants.nextShortKey) ?? nextShortKey
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
    
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
}
