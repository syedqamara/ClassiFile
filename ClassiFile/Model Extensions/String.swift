//
//  String.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa
var normalColor = NSColor.white
extension NSColor {
    class var purpleCodeColor: NSColor {
//        return NSColor(calibratedRed: 190, green: 47, blue: 180, alpha: 1.0)
        return NSColor.init(named: NSColor.Name(rawValue: "predefinePurpleColor"))!
    }
    class var blueCodeColor: NSColor {
//        return NSColor(calibratedRed: 104, green: 58, blue: 150, alpha: 1.0)
        return NSColor.init(named: NSColor.Name(rawValue: "codeBlueColor"))!
    }
    class var userdefineCodeColor: NSColor {
        return NSColor.init(named: NSColor.Name(rawValue: "userdefineGreenColor"))!
    }
    class var commentCodeColor: NSColor {
        return NSColor.init(named: NSColor.Name(rawValue: "commentGreenColor"))!
    }
}

extension String {
    mutating func addMark(_ typeName: MarkType) {
        let markString = "//MARK: - \(typeName.rawValue)" + kBackSlashN
        self = markString + self
    }
    func addColofullMark(_ typeName: MarkType) -> NSAttributedString {
        let markString = "//MARK: - \(typeName.rawValue)" + kBackSlashN
        return markString.commentWord
    }
    func colorFullString(color: NSColor) -> NSAttributedString {
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor: color])
        return attributedString
    }
    func codeColorFullString(color: NSColor) -> NSAttributedString {
        let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 16, weight: .regular)]
        let attributedString = NSAttributedString(string: self, attributes: attr)
        
        return attributedString
    }
    var purpleKeyWord: NSAttributedString {
        let color = NSColor.purpleCodeColor
        return codeColorFullString(color: color)
    }
    var blueKeyWord: NSAttributedString {
        let color = NSColor.blueCodeColor
        return codeColorFullString(color: color)
    }
    var userdefineWord: NSAttributedString {
        let color = NSColor.userdefineCodeColor
        return codeColorFullString(color: color)
    }
    var commentWord: NSAttributedString {
        let color = NSColor.commentCodeColor
        return codeColorFullString(color: color)
    }
    var normalWord: NSAttributedString {
        let color = normalColor
        return codeColorFullString(color: color)
    }
    
    static var dictionaryName: NSAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append("[".normalWord)
        mutableString.append("String".blueKeyWord)
        mutableString.append(":".normalWord)
        mutableString.append("AnyObject".blueKeyWord)
        mutableString.append("]".normalWord)
        return mutableString
    }
    static var asDictionaryName: NSAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append("as?".purpleKeyWord)
        mutableString.append("[".normalWord)
        mutableString.append("String".blueKeyWord)
        mutableString.append(":".normalWord)
        mutableString.append("AnyObject".blueKeyWord)
        mutableString.append("]".normalWord)
        return mutableString
    }
    
    
}
