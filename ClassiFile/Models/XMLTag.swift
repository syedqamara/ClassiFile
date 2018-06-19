//
//  XMLTag.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/20/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class XMLTag: NSObject {
    var name = ""
    var attributes = [XMLAttribute]()
    var xmlTags = [XMLTag]()
    var shouldIncludeEndingTag = false
    
    
    var generate: String {
        var endingTag = ""
        if !shouldIncludeEndingTag {
            endingTag = "/"
        }
        var tags = "<\(endingTag)\(name)\(attributes.combineTags)>"
        tags += xmlTags.combineTags
        if shouldIncludeEndingTag {
            tags += "</\(name)>"
        }
        return tags
    }
}

class XMLAttribute: NSObject {
    var name = ""
    var value = ""
    init(_ attrName: String, _ attrValue: String) {
        super.init()
        name = attrName
        value = attrValue
    }
    var xmlAttribute: String {
        return "\(name)=\(value)"
    }
}
extension Array where Element: XMLAttribute {
    var combineTags: String {
        var tags = ""
        for attr in self {
            tags += " "
            tags += attr.xmlAttribute
        }
        return tags
    }
}
extension Array where Element: XMLTag {
    var combineTags: String {
        var tags = ""
        for tag in self {
            tags += "\n"
            tags += tag.generate
        }
        return tags
    }
}
