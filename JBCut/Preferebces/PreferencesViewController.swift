//
//  PreferencesViewController.swift
//  JBCut
//
//  Created by 任金波 on 2019/8/12.
//  Copyright © 2019 任金波. All rights reserved.
//

import Cocoa


class GeneralViewController: NSViewController {
        
    @IBOutlet weak var launchButton: NSButton!
    
    @IBOutlet weak var showMenuButton: NSButton!
    @IBOutlet weak var selectionPasteButton: NSButton!
    @IBOutlet weak var saveTimeButton: NSPopUpButton!
    @IBOutlet weak var remenberLabel: NSTextField!
    @IBOutlet weak var displayLabel: NSTextField!
    @IBOutlet weak var rememberStepper: NSStepper!
    @IBOutlet weak var displayStepper: NSStepper!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("GeneralView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchButton.state = NSButton.StateValue.init(GlobalVariable.shared.launchAtLogin)
        showMenuButton.state = NSButton.StateValue.init(GlobalVariable.shared.menuShowHistory)
        selectionPasteButton.state = NSButton.StateValue.init(GlobalVariable.shared.menuSelectPastes)
        
        saveTimeButton.selectItem(at: GlobalVariable.shared.saveTime)
        
        remenberLabel.integerValue = GlobalVariable.shared.clipMenuCount;
        rememberStepper.integerValue = GlobalVariable.shared.clipMenuCount;
        
        displayLabel.integerValue = GlobalVariable.shared.displayMenuCount;
        displayStepper.integerValue = GlobalVariable.shared.displayMenuCount;
    }
    
    //MARK: - action
    @IBAction func launchButtonClick(_ sender: NSButton) {
        GlobalVariable.shared.launchAtLogin = sender.state.rawValue;
        UserDefaults.standard.set(GlobalVariable.shared.launchAtLogin, forKey: JBConstants.launchAtLogin)
        LoginItem.checkAppStartWithLoginItem()
    }
    @IBAction func showMenuButtonClick(_ sender: NSButton) {
        GlobalVariable.shared.menuShowHistory = sender.state.rawValue;
        UserDefaults.standard.set(GlobalVariable.shared.menuShowHistory, forKey: JBConstants.showHistory)
    }
    @IBAction func selectPastesButtonClick(_ sender: NSButton) {
        GlobalVariable.shared.menuSelectPastes = sender.state.rawValue;
        UserDefaults.standard.set(GlobalVariable.shared.menuSelectPastes, forKey: JBConstants.selectPastes)
    }
    @IBAction func saveTimeButtonClick(_ sender: NSPopUpButton) {
        GlobalVariable.shared.saveTime = sender.indexOfSelectedItem;
        UserDefaults.standard.set(GlobalVariable.shared.saveTime, forKey: JBConstants.saveTime)
    }
    
    @IBAction func rememberStepperClick(_ sender: NSStepper) {
        remenberLabel.integerValue = sender.integerValue
        GlobalVariable.shared.clipMenuCount = sender.integerValue;
        UserDefaults.standard.set(GlobalVariable.shared.clipMenuCount, forKey: JBConstants.clipMenuCount)
        
        NotificationCenter.default.post(name: NSNotification.Name.init(JBConstants.Notification.clipMenuCountChanged), object: nil)
    }
    @IBAction func displayStepperClick(_ sender: NSStepper) {
        displayLabel.integerValue = sender.integerValue
        GlobalVariable.shared.displayMenuCount = sender.integerValue;
        UserDefaults.standard.set(GlobalVariable.shared.displayMenuCount, forKey: JBConstants.displayMenuCount)
    }
}


class HotkeysViewController: NSViewController {
    
    @IBOutlet weak var preRecordView: JBRecordView!
    
    @IBOutlet weak var nextRecordView: JBRecordView!
    
    @IBOutlet weak var imageButton: NSButton!

    override var nibName: NSNib.Name? {
        return NSNib.Name("HotkeyView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preRecordView.hotKey = GlobalVariable.shared.preShortKey
        preRecordView.delegate = self
        
        nextRecordView.hotKey = GlobalVariable.shared.nextShortKey
        nextRecordView.delegate = self
    }
}

extension HotkeysViewController: RecordViewDelegate {
    func recordViewDidBeginRecord(_ recordView: JBRecordView) {
        
    }
    
    func recordViewDidFinishRecord(_ recordView: JBRecordView, _ isVaildKey: Bool, _ keyStruct: JBShortKey) {
        if !isVaildKey {
            return
        }
        
        if recordView == self.preRecordView {
            GlobalVariable.shared.preShortKey = keyStruct
            UserDefaults.standard.setStruct(keyStruct, forKey: JBConstants.preShortKey)
        } else {
            GlobalVariable.shared.nextShortKey = keyStruct
            UserDefaults.standard.setStruct(keyStruct, forKey: JBConstants.nextShortKey)
        }
        
        HotKeyCenter.shared.registerHotkey()
    }
}


class AppearanceViewController: NSViewController {
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("AppearanceView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
