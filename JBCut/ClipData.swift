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
    
    override init() {
        clipString = ""
        timeStamp = 100000
        super.init()
    }
    
    required init?(coder: NSCoder) {
        
        clipString = coder.decodeObject(forKey: "clipString") as! String
        timeStamp = coder.decodeInteger(forKey: "timeStamp")
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(clipString, forKey: "clipString")
        coder.encode(timeStamp, forKey: "timeStamp")
    }
    
}
