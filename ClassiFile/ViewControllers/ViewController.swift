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
protocol EditClassViewControllerDelegate: NSObjectProtocol {
    func changedClass(classObject: Class, from viewController: ViewController)
}

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var topView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var typeOption: NSPopUpButton!
    @IBOutlet weak var sortCheckBox: NSButton!
    @IBOutlet weak var filterCheckBox: NSButton!
    @IBOutlet weak var classNameTF: NSTextField!
    
    var isEditMode = false
    var delegate: EditClassViewControllerDelegate?
    
    var classObj = Class()
    var resetVariableFields: Void {
        nameTextField.stringValue = ""
        sortCheckBox.state = NSControl.StateValue.off
        filterCheckBox.state = NSControl.StateValue.off
        typeOption.select(typeOption.itemArray.first)
        if isEditMode {
            topView.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.resetVariableFields
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return classObj.variables.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier.rawValue else {return nil}
        guard let coloumnType = ColoumnIdentifier(rawValue: identifier) else {return nil}
        let variable = self.classObj.variables[row]
        switch coloumnType {
        case .name:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = variable.name
                return cell
            }
        case .type:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = variable.type.rawValue
                return cell
            }
        case .filter:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = "Filter/Find Method"
                cell.imageView?.image = #imageLiteral(resourceName: "disable")
                if variable.shouldHaveFindFilterMethod {
                    cell.imageView?.image = #imageLiteral(resourceName: "enable")
                }
                return cell
            }
        case .sort:
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = "Sort Method"
                cell.imageView?.image = #imageLiteral(resourceName: "disable")
                if variable.shouldHaveSortMethod {
                    cell.imageView?.image = #imageLiteral(resourceName: "enable")
                }
                return cell
            }
        default:
            break
        }
        return nil
    }
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
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
        panel.directoryURL = URL(string: "~/Documents/")!
        // 4
        
        panel.nameFieldStringValue = fileURL.lastPathComponent
        
        // 5
        let result = panel.runModal()
        if result == NSApplication.ModalResponse.OK,
            let url = panel.url {
            // 6
            do {
                try infoAsText.write(to: url, atomically: true, encoding: .utf8)
                if file is Class {
                    let fileExtension = Extension(with: self.classObj)
                    fileExtension.save()
                    self.save(fileExtension, completion)
                }
                
            } catch {
                self.showErrorDialogIn(title: "Unable to save file",
                                       message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        if isEditMode {
            if let del = self.delegate {
                del.changedClass(classObject: classObj, from: self)
            }
        }else {
            let classNameObj = classNameTF.stringValue.replacingOccurrences(of: ".swfit", with: "")
            classObj.name = classNameObj
            saveClass()
        }
    }
    @IBAction func didTapPlusButton(_ sender: Any) {
        let newVar = Variable()
        newVar.name = nameTextField.stringValue
        if let titleOfOption = typeOption.selectedItem?.title, let varType = VariableType(rawValue: titleOfOption) {
            newVar.type = varType
        }
        newVar.shouldHaveSortMethod = sortCheckBox.state.rawValue == 1
        newVar.shouldHaveFindFilterMethod = filterCheckBox.state.rawValue == 1
        classObj.variables.append(newVar)
        self.resetVariableFields
        self.tableView.reloadData()
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

