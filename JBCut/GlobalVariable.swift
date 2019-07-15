//
//  GlobalVariable.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/12.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class GlobalVariable: NSObject {
    
    public static let shared = GlobalVariable()
    
    var clipMenuCount: Int = 20
    var displayLength: Int = 40

    func readDataFronUserDefault() {
        clipMenuCount = UserDefaults.standard.getIntValue(key: "clipMenuCount", defaultValue: 20)
        displayLength = UserDefaults.standard.getIntValue(key: "displayLength", defaultValue: 40)

        print(clipMenuCount)        
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
}
