//
//  NSBezierPath+background.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/10.
//  Copyright © 2019 任金波. All rights reserved.
//

import Foundation
import Cocoa

extension NSBezierPath {
    public func getBeizerPath(aRect: NSRect, radius: CGFloat) -> NSBezierPath {
        let path: NSBezierPath = NSBezierPath()
        
        let nowRadius = min(radius, CGFloat(0.5 * min(aRect.width, aRect.height)))
        let nowRect = NSInsetRect(aRect, CGFloat(radius), radius)
        
        path.appendArc(withCenter: NSPoint(x: NSMinX(nowRect), y: NSMinY(nowRect)), radius: nowRadius, startAngle: 180.0, endAngle: 270.0)
        path.appendArc(withCenter: NSPoint(x: NSMaxX(nowRect), y: NSMinY(nowRect)), radius: nowRadius, startAngle: 270.0, endAngle: 360.0)
        path.appendArc(withCenter: NSPoint(x: NSMaxX(nowRect), y: NSMaxY(nowRect)), radius: nowRadius, startAngle: 0.0, endAngle: 90.0)
        path.appendArc(withCenter: NSPoint(x: NSMinX(nowRect), y: NSMaxY(nowRect)), radius: nowRadius, startAngle: 90.0, endAngle: 180.0)
        
        path.close()
        return path;
    }
}
