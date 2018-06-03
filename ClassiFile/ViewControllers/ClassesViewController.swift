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

class ClassesViewController: NSViewController {
    
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var outlineView: NSOutlineView!
    var feeds = [Class]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//                    button?.tag = tableColumn.r
                    button?.action = #selector(ClassesViewController.didTapEditButtonAtIndex(button:))
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
            }
        }
        //More code here
        return view
    }
    @objc func didTapEditButtonAtIndex(button: NSButton) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "edit"), sender: button)
    }
    func textIsChange(viewController: TextEditViewController, text: String, isChanged: Bool, forIndex: Int) {
        let oldName = PostManRequestManager.shared.classes[forIndex].name
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
        DispatchQueue.global(qos: .background).async {
            PostManRequestManager.shared.classes.updateClassName(oldName, className: text, forIndex)
            self.feeds = PostManRequestManager.shared.classes
            DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                self.dismissViewController(viewController)
                self.outlineView.reloadData()
            }
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "edit" {
            let destVC = segue.destinationController as! TextEditViewController
            let button = sender as! NSButton
            destVC.selectedIndex = button.tag
            destVC.oldText = feeds[button.tag].name
            destVC.delegate = self
        }
    }
    func outlineViewSelectionDidChange(_ notification: Notification) {
        //1
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        //2
        let selectedIndex = outlineView.selectedRow
        
        if let classObj = outlineView.item(atRow: selectedIndex) as? Class {
            self.textView.string = ""
            self.textView.textStorage?.append(classObj.colorfullCompleteClass)
            
        }
    }
}
