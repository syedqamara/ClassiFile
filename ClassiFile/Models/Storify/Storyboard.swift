//
//  Storyboard.swift
//  ClassiFile
//
//  Created by Syed Qamar Abbas on 06/04/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class KeyValue: NSObject {
    var key: String?
    var value: String?
    
    init?(keyValueString: String) {
        let dataArray = keyValueString.components(separatedBy: "=")
        if dataArray.count == 2 {
            key = dataArray[0]
            value = dataArray[1]
            return
        }
        return nil
    }
    
    var toString: String {
        var mainString = ""
        if let k = key {
            mainString += k + "="
        }
        if let v = value {
            mainString += v
        }
        return mainString
    }
    
}

class Storyboard: NSObject {
    var title: String?
    
}
class ParseObject: NSObject {
    var key: String?
    var titleAttributes = [KeyValue]()
    var centerData: Any?
    
    fileprivate var starter: String {
        var str = "<"
        if let k = key {
            str += k
        }
        return str
    }
    fileprivate var terminator: String {
        var str = "\n</"
        if let k = key {
            str += k
        }
        return str + ">"
    }
    
    var toXMLString: String {
        var mainString = starter
        
        return mainString
    }
}
//<?xml version="1.0" encoding="UTF-8" standalone="no"?>
//<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="13142" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">

//<dependencies>
//<plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="12042"/>
//</dependencies>
//<scenes/>
//</document>

