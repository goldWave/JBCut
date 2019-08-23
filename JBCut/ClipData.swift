//
//  ClipModel.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/4.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

class ClipData: NSObject, NSCoding {
    
    var clipString: String
    var timeStamp: Int
    var appIconPath: String
    
    var displayMenuString: String {
        get {
            if clipString.isEmpty {return ""}
            
            // We want to restrict the display string to the clipping contents through the first line break.
            var trimmedString: NSString = clipString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
            
            var lineStart = 0, lineEnd = 0, contentsEnd = 0
            let aRang = NSRange(location: 0, length: 0)
            trimmedString.getLineStart(&lineStart, end: &lineEnd, contentsEnd: &contentsEnd, for: aRang)
            if trimmedString.length > GlobalVariable.shared.displayLength {
                trimmedString = trimmedString.substring(to: GlobalVariable.shared.displayLength) as NSString
                trimmedString = trimmedString.appending("...") as NSString
            }
            return trimmedString as String
        }
    }
    
    override init() {
        clipString = "Display data"
        timeStamp = Int(NSDate().timeIntervalSince1970)
        appIconPath = Bundle.main.bundlePath
        super.init()
    }
    
    required init?(coder: NSCoder) {
        
        clipString = coder.decodeObject(forKey: "clipString") as! String
        timeStamp = coder.decodeInteger(forKey: "timeStamp")
        appIconPath = coder.decodeObject(forKey: "appIconPath") as! String
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(clipString, forKey: "clipString")
        coder.encode(timeStamp, forKey: "timeStamp")
        coder.encode(appIconPath, forKey: "appIconPath")
    }
}
