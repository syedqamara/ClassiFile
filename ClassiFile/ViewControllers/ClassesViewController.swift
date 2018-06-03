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
  
  @IBOutlet weak var webView: WebView!
  @IBOutlet weak var outlineView: NSOutlineView!
  var feeds = [Feed]()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateFormatter.dateStyle = .short
    
    if let filePath = Bundle.main.path(forResource: "Feeds", ofType: "plist") {
      feeds = Feed.feedList(filePath)
      print(feeds)
    }
  }
  
  @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
    //1
    let item = sender.item(atRow: sender.clickedRow)
    
    //2
    if item is Feed {
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
      if let item = item as? Feed {
        //5
        if let index = self.feeds.index( where: {$0.name == item.name} ) {
          //6
          self.feeds.remove(at: index)
          //7
          outlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
        }
      } else if let item = item as? FeedItem {
        //8
        for feed in self.feeds {
          //9
          if let index = feed.children.index( where: {$0.title == item.title} ) {
            feed.children.remove(at: index)
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
    if let feed = item as? Feed {
      return feed.children.count
    }
    //2
    return feeds.count
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if let feed = item as? Feed {
      return feed.children[index]
    }
    
    return feeds[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    if let feed = item as? Feed {
      return feed.children.count > 0
    }
    
    return false
  }
}

extension ClassesViewController: NSOutlineViewDelegate {
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    //1
    if let feed = item as? Feed {
      if tableColumn?.identifier == "DateColumn" {
        view = outlineView.make(withIdentifier: "DateCell", owner: self) as? NSTableCellView
        if let textField = view?.textField {
          textField.stringValue = ""
          textField.sizeToFit()
        }
      } else {
        view = outlineView.make(withIdentifier: "FeedCell", owner: self) as? NSTableCellView
        if let textField = view?.textField {
          textField.stringValue = feed.name
          textField.sizeToFit()
        }
      }
    } else if let feedItem = item as? FeedItem {
      //1
      if tableColumn?.identifier == "DateColumn" {
        //2
        view = outlineView.make(withIdentifier: "DateCell", owner: self) as? NSTableCellView
        
        if let textField = view?.textField {
          //3
          textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
          textField.sizeToFit()
        }
      } else {
        //4
        view = outlineView.make(withIdentifier: "FeedItemCell", owner: self) as? NSTableCellView
        if let textField = view?.textField {
          //5
          textField.stringValue = feedItem.title
          textField.sizeToFit()
        }
      }
    }
    //More code here
    return view
  }
  
  func outlineViewSelectionDidChange(_ notification: Notification) {
    //1
    guard let outlineView = notification.object as? NSOutlineView else {
      return
    }
    
    //2
    let selectedIndex = outlineView.selectedRow
    
    if let feedItem = outlineView.item(atRow: selectedIndex) as? FeedItem {
      //3
      let url = URL(string: feedItem.url)
      //4
      if let url = url {
        //5
        self.webView.mainFrame.load(URLRequest(url: url))
      }
    }
  }
}
