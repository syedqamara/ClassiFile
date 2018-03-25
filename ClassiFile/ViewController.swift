//
//  ViewController.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var classObj = Class()
    override func viewDidLoad() {
        super.viewDidLoad()
        classObj.name = "User"
        classObj.addVariable("id", .int, false, true)
        classObj.addVariable("Name", .int, false, true)
        classObj.addVariable("Age", .int, true, true)
        classObj.addVariable("dob", .int, true, false)
        classObj.addVariable("present", .int, false, false)
        
        saveClass()
        
        
        
//        ModelManager.shared.saveClass(classFile: classObj)
        // Do any additional setup after loading the view.
    }
    
    func saveClass() {
        classObj.save()
        save(classObj) {
            if self.classObj.shouldCreateExtension {
                let ext = Extension(with: self.classObj)
                ext.save()
                self.save(ext, {
                    print("Saved All Data")
                })
            }
        }
    }
    
    func save(_ file: File, _ completion: @escaping ()->()) {
        guard let fileURL = file.localURL else {return}
        guard let infoAsText = file.completeClass else {return}
        // 2
        let panel = NSSavePanel()
        // 3
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        // 4
        
        panel.nameFieldStringValue = fileURL.lastPathComponent
        
        // 5
        let result = panel.runModal()
        if result == NSApplication.ModalResponse.OK,
            let url = panel.url {
            // 6
            do {
                try infoAsText.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                self.showErrorDialogIn(title: "Unable to save file",
                                       message: error.localizedDescription)
            }
        }
    }
    func showErrorDialogIn(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.runModal()
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

