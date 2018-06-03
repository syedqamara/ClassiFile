//
//  TextEditViewController.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa
protocol TextEditVCDelegate {
    func textIsChange(viewController: TextEditViewController, text: String, isChanged: Bool, forIndex: Int)
}

class TextEditViewController: NSViewController,NSTextFieldDelegate {

    var selectedIndex = 0
    var oldText = ""
    var delegate: TextEditVCDelegate?
    @IBOutlet weak var textField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.stringValue = oldText
        // Do view setup here.
    }
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 53 {
            self.dismissViewController(self)
        }
    }
    @IBAction func didTapSaveButton(_ sender: Any) {
        var isChanged = false
        if textField.stringValue != oldText {
            isChanged = true
        }
        if let del = self.delegate {
            del.textIsChange(viewController: self, text: textField.stringValue, isChanged: isChanged, forIndex: selectedIndex)
        }
    }
}


