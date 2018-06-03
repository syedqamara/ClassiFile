//
//  BaseViewController.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
typealias Callback = (NSEvent) -> ()

class KeyCaptureWindow: NSWindow {
    
    
}
class VariableButton: NSButton {
    var variable: Variable?
}
