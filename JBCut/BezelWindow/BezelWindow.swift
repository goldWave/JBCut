//
//  BezelWindow.swift
//  JBCut
//
//  Created by 任金波 on 2019/7/3.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa

protocol BezelWindowDelegate: class {
    func metaKeysReleased()
}

class BezelWindow: NSPanel {
    

    public weak var  bezeDelegate: BezelWindowDelegate?
    private var bezelView: BezelView!
    
    override var canBecomeKey: Bool {
        return true
    }
    
    init(cusSzie: NSRect) {
        super.init(contentRect: cusSzie,
                   styleMask: NSWindow.StyleMask.borderless,
                   backing: NSWindow.BackingStoreType.buffered,
                   defer: false)
        
        
        self.level = NSWindow.Level.screenSaver
        self.isOpaque = false
        self.alphaValue = 1.0
        self.isOpaque = false
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
        self.backgroundColor = NSColor.clear
        bezelView = BezelView(frame: cusSzie)
        self.contentView?.addSubview(bezelView)
    }
    
    public func reassembleSubView() {
        bezelView.reassembleSubView()
    }
    
    public func changeBgColor() {
        bezelView.changeBgColor()
    }
    
    public func setCurrentData(data: ClipData, indexString: String) {
        bezelView.setCurrentData(data: data, indexString: indexString)
    }
    
    override func flagsChanged(with event: NSEvent) {
        if !(event.modifierFlags.contains(.command)) &&
            !(event.modifierFlags.contains(.option)) &&
            !(event.modifierFlags.contains(.control)) &&
            !(event.modifierFlags.contains(.shift)) &&
            self.bezeDelegate != nil {
            self.bezeDelegate?.metaKeysReleased()
        }
    }
        
    public func adjustWindowToCenter() {
        let scrrenFrame: CGRect = NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let originFrame = NSPoint(x: (scrrenFrame.size.width - NSWidth(self.frame)) * 0.5 + scrrenFrame.origin.x, y: (scrrenFrame.size.height - NSHeight(self.frame)) * 0.5 + scrrenFrame.origin.y)
        self.setFrameOrigin(originFrame)
    }
}

extension Int {
    func timeFormateChange() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate = dateFormatter.string(from: date)
        return nowDate
    }
}
