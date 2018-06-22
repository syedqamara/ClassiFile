//
//  BaseViewController.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa
typealias AlertResponseHandler = (Int)->()
class BaseViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    func showAlert(_ title: String, _ message: String,_ buttonTitles: [String] = [], _ alertType: NSAlert.Style, completion: AlertResponseHandler? = nil) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = alertType
        for bTitle in buttonTitles {
            alert.addButton(withTitle: bTitle)
        }
        let result = alert.runModal()
        if let com = completion {
            com(result.rawValue)
        }
    }
}
typealias Callback = (NSEvent) -> ()

class KeyCaptureWindow: NSWindow {
    
    
}
class VariableButton: NSButton {
    var variable: Variable?
}

