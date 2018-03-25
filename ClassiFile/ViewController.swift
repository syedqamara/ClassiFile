//
//  ViewController.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

enum ColoumnIdentifier: String {
    case name = "1"
    case type = "2"
    case filter = "3"
    case sort = "4"
}

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var tableView: NSTableView!
    var classObj = Class()
    var rowCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
//        classObj.name = "User"
//        classObj.addVariable("id", .int, false, true)
//        classObj.addVariable("Name", .int, false, true)
//        classObj.addVariable("Age", .int, true, true)
//        classObj.addVariable("dob", .int, true, false)
//        classObj.addVariable("present", .int, false, false)
        
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rowCount
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier.rawValue else {return nil}
        guard let coloumnType = ColoumnIdentifier(rawValue: identifier) else {return nil}
        switch coloumnType {
        case .name:
            return variableNames()
        case .type:
            return variableTypes()
        case .filter:
            return variableFilter()
        case .sort:
            return variableSort()
        default:
            break
        }
        return nil
    }
    func variableNames() -> NSView? {
        return nil
    }
    func variableTypes() -> NSView? {
        return nil
    }
    func variableFilter() -> NSView? {
        return nil
    }
    func variableSort() -> NSView? {
        return nil
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
    
    @IBAction func didTapSaveButton(_ sender: Any) {
    }
    @IBAction func didTapPlusButton(_ sender: Any) {
        let indexSet: IndexSet = [rowCount]
        rowCount += 1
        tableView.beginUpdates()
        tableView.insertRows(at: indexSet, withAnimation: .slideLeft)
        tableView.endUpdates()
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

