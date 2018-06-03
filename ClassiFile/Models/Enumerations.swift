//
//  Enumerations.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

enum CodeSecurity: String {
    case publicVar = "public"
    case internalVar = "internal"
    case openVar = "open"
    case privateVar = "private"
    case filePrivateVar = "filePrivate"
}

enum VariableType: String {
    case int = "Int"
    case string = "String"
    case float = "Float"
    case double = "Double"
    case bool = "Bool"
    case date = "Date"
    case void = "Void"
    case customClass = "CustomClass"
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum PostmanModeType: String {
    case raw = "raw"
    case formData = "form-data"
    case formdata = "formdata"
    case xurlform = "x-www-form-urlencoded"
    case none = ""
}
