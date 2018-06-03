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
typealias TextEditCompletion = (viewController: TextEditViewController, text: String, isChanged: Bool, index: Int, section: Int)
class TextEditViewController: NSViewController,NSTextFieldDelegate {

    var selectedIndex = 0
    var selectedSection = 0
    var oldText = ""
    var delegate: TextEditVCDelegate?
    var completion: ((TextEditCompletion)->())?
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
        else if event.keyCode == 36 {
            save()
        }
    }
    @IBAction func didTapSaveButton(_ sender: Any) {
        save()
    }
    func changedVariabled(completion: @escaping (TextEditCompletion)->()) {
        self.completion = completion
    }
    fileprivate func save() {
        var isChanged = false
        if textField.stringValue != oldText {
            isChanged = true
        }
        if let del = self.delegate {
            del.textIsChange(viewController: self, text: textField.stringValue, isChanged: isChanged, forIndex: selectedIndex)
        }
        if let com = self.completion {
            let response = TextEditCompletion(self, textField.stringValue, isChanged, selectedIndex, selectedSection)
            com(response)
        }
    }
}


