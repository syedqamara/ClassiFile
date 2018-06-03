//
//  ClassCellView.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class ClassCellView: NSTableCellView {

    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var classEditButton: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
}
class VariableCell : NSTableCellView {
    
    @IBOutlet weak var editButton: VariableButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
}
