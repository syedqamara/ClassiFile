/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Cocoa
import WebKit

class ClassesViewController: BaseViewController, EditClassViewControllerDelegate {
    
    var currentClass = Class(with: "NSObject")
    var isNight = true
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var outlineView: NSOutlineView!
    var feeds = [Class]()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var nightModelButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeNightButtonTitle()
    }
    func changeNightButtonTitle() {
        if isNight {
            nightModelButton.title = "Light Mode"
        }else {
            nightModelButton.title = "Night Mode"
        }
    }
    @IBAction func didTapSaveAllButton(_ sender: Any) {
        PostManRequestManager.shared.save {
            print("Saved")
        }
    }
    
    @IBAction func nightModeButtonIsClicked(_ sender: Any) {
        isNight = !isNight
        var color = NSColor.white
        if isNight {
            color = NSColor.black
            normalColor = NSColor.white
        }else {
            normalColor = NSColor.black
            color = NSColor.white
        }
        changeNightButtonTitle()
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            self.textView.animator().backgroundColor = color
        }, completionHandler: {
            self.changeTextViewText()
        })
        
        outlineView.reloadData()
    }
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        //1
        let item = sender.item(atRow: sender.clickedRow)
        
        //2
        if item is Class {
            //3
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }
    
    override func deleteBackward(_ sender: Any?) {
        //1
        let selectedRow = outlineView.selectedRow
        if selectedRow == -1 {
            return
        }
        
        //2
        outlineView.beginUpdates()
        //3
        if let item = outlineView.item(atRow: selectedRow) {
            
            //4
            if let item = item as? Class {
                //5
                if let index = self.feeds.index( where: {$0.name == item.name} ) {
                    //6
                    self.feeds.remove(at: index)
                    //7
                    outlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
                }
            } else if let item = item as? Variable {
                //8
                for feed in self.feeds {
                    //9
                    if let index = feed.variables.index( where: {$0.name == item.name} ) {
                        feed.variables.remove(at: index)
                        outlineView.removeItems(at: IndexSet(integer: index), inParent: feed, withAnimation: .slideLeft)
                    }
                }
            }
        }
        outlineView.endUpdates()
    }
}

extension ClassesViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        //1
        if let feed = item as? Class {
            return feed.variables.count
        }
        //2
        return feeds.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let feed = item as? Class {
            return feed.variables[index]
        }
        
        return feeds[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let feed = item as? Class {
            return feed.variables.count > 0
        }
        
        return false
    }
}

extension ClassesViewController: NSOutlineViewDelegate, TextEditVCDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        //1
        if let feed = item as? Class {
            if (tableColumn?.identifier)!.rawValue == "DateColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feed.name + ".swift"
                    textField.sizeToFit()
                }
                if let cell = view as? ClassCellView {
                    let button = cell.editButton
                    let index = feeds.findIndex(feed)
                    if index != -1 {
                        button?.tag = index
                    }else {
                        button?.isHidden = true
                    }
                    let haveAnyEqualClass = PostManRequestManager.shared.isSameClass(feed).count > 0
                    let didConformsToInheritance = PostManRequestManager.shared.isConformToInheritance(feed).count > 0
                    let shouldHideWarningButton = (!haveAnyEqualClass) && (!didConformsToInheritance)
                    
                    if haveAnyEqualClass {
                        cell.warningButton.image = #imageLiteral(resourceName: "Image")
                    }
                    else if didConformsToInheritance {
                        cell.warningButton.image = #imageLiteral(resourceName: "inheritance")
                    }
                    cell.warningButton.isHidden = shouldHideWarningButton
                    button?.action = #selector(ClassesViewController.didTapEditButtonAtIndex(button:))
                    cell.classEditButton.tag = index
                    cell.warningButton.tag = index
                    cell.classEditButton.action = #selector(ClassesViewController.didTapEditClassButton(button:))
                    cell.warningButton.action = #selector(ClassesViewController.didTapWarningButton(button:))
                }
            }
        } else if let feedItem = item as? Variable {
            //1
            if (tableColumn?.identifier)!.rawValue == "DateColumn" {
                //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    //3
                    textField.attributedStringValue = feedItem.getAttributedVariableTypeName
                    textField.sizeToFit()
                }
            } else {
                //4
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedItemCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    //5
                    textField.stringValue = feedItem.name
                    textField.sizeToFit()
                }
                if let cellView = view as? VariableCell {
                    cellView.editButton.variable = feedItem
                    cellView.editButton.action = #selector(ClassesViewController.didTapVariableEditButtonAtIndex(button:))
                }
            }
        }
        //More code here
        return view
    }
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 40
    }
    @objc func didTapEditButtonAtIndex(button: NSButton) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "edit"), sender: button)
    }
    @objc func didTapEditClassButton(button: NSButton) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "editClass"), sender: button)
    }
    @objc func didTapWarningButton(button: VariableButton) {
        let index = button.tag
        let selectedClass = PostManRequestManager.shared.classes[index]
        
        let haveAnyEqualClass = PostManRequestManager.shared.isSameClass(selectedClass).count > 0
        let didConformsToInheritance = PostManRequestManager.shared.isConformToInheritance(selectedClass).count > 0
        if haveAnyEqualClass {
            showAlertForEqualClassWith(selectedClass)
        }else if didConformsToInheritance {
            showAlertForBaseClassWith(selectedClass)
        }
        
    }
    func showAlertForEqualClassWith(_ selectedClass: Class) {
        let matchedClasses = PostManRequestManager.shared.isSameClass(selectedClass)
        self.showAlert("Warning", "Your class \(selectedClass.name) is same class of name \(matchedClasses.className).\n Are you want to merge them in a single class with name \(selectedClass.name)",["YES", "NO"], .warning, completion: {index in
            if index == 1000 {
                for mClass in matchedClasses {
                    let classIndex = PostManRequestManager.shared.classes.findIndex(mClass)
                    PostManRequestManager.shared.classes.remove(at: classIndex)
                }
                self.feeds = PostManRequestManager.shared.classes
                DispatchQueue.main.async {
                    self.outlineView.reloadData()
                }
            }
        })
    }
    
    func showAlertForBaseClassWith(_ selectedClass: Class) {
        let matchedClasses = PostManRequestManager.shared.isConformToInheritance(selectedClass)
        self.showAlert("Warning", "Your class \(selectedClass.name) is have more than 3 common attributes with classes **[ \(matchedClasses.className)]**.\n Do you want to generate a common base class with name Base\(selectedClass.name)",["YES for all classes", "NO"], .warning, completion: {index in
//            if index == 1000 {
//                PostManRequestManager.shared.createBaseClass(for: selectedClass)
//                self.feeds = PostManRequestManager.shared.classes
//                DispatchQueue.main.async {
//                    self.outlineView.reloadData()
//                }
//            }else
            if index == 1000 {
                PostManRequestManager.shared.createBaseClass(for: selectedClass)
                for mClass in matchedClasses {
                    PostManRequestManager.shared.createBaseClass(for: mClass)
                }
                self.feeds = PostManRequestManager.shared.classes
                DispatchQueue.main.async {
                    self.outlineView.reloadData()
                }
            }
        })
    }
    @objc func didTapVariableEditButtonAtIndex(button: NSButton) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "edit"), sender: button)
    }
    func textIsChange(viewController: TextEditViewController, text: String, isChanged: Bool, forIndex: Int) {
        let oldName = PostManRequestManager.shared.classes[forIndex].name
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
        DispatchQueue.global(qos: .background).async {
            PostManRequestManager.shared.classes.updateClassName(oldName, className: text, forIndex)
            self.reloadScreen(viewController: viewController)
        }
    }
    func changedClass(classObject: Class, from viewController: ViewController) {
        let index = PostManRequestManager.shared.classes.findIndex(classObject)
        if index != -1 {
            PostManRequestManager.shared.classes[index] = classObject
        }
        reloadScreen(viewController: viewController)
    }
    func reloadScreen(viewController: NSViewController) {
        self.feeds = PostManRequestManager.shared.classes
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
            self.dismissViewController(viewController)
            self.outlineView.reloadData()
            self.changeTextViewText()
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "edit" {
            openTextEditViewController(segue: segue, sender: sender)
        }
        else if segue.identifier?.rawValue == "editClass" {
            openClassEditViewController(segue: segue, sender: sender)
        }
    }
    
    func openClassEditViewController(segue: NSStoryboardSegue, sender: Any?) {
        let destVC = segue.destinationController as! ViewController
        if let button = sender as? NSButton {
            destVC.isEditMode = true
            destVC.classObj = self.feeds[button.tag]
        }
        destVC.delegate = self
    }
    func openTextEditViewController(segue: NSStoryboardSegue, sender: Any?) {
        let destVC = segue.destinationController as! TextEditViewController
        if let button = sender as? VariableButton, let variable = button.variable, let indexPath = feeds.getIndexPathOfVariable(variable) {
            destVC.selectedSection = indexPath.section
            destVC.selectedIndex = indexPath.item
            destVC.oldText = variable.name
            destVC.changedVariabled(completion: { (textEdit) in
                PostManRequestManager.shared.classes[textEdit.section].variables[textEdit.index].name = textEdit.text
                self.reloadScreen(viewController: textEdit.viewController)
            })
        }
        else if let button = sender as? NSButton {
            destVC.selectedIndex = button.tag
            destVC.oldText = feeds[button.tag].name
            destVC.delegate = self
        }
    }
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        let selectedIndex = outlineView.selectedRow
        if let classObj = outlineView.item(atRow: selectedIndex) as? Class {
            self.currentClass = classObj
            changeTextViewText()
        }
    }
    func changeTextViewText() {
        self.textView.string = ""
        self.textView.textStorage?.append(self.currentClass.colorfullCompleteClass)
    }
}
