//
//  Variable.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa
let kTapSpace = "    "
class Constant {
    static let jsonCreation = "    var json = [String: AnyObject]()"
    static var colorfullJsonCreation: NSAttributedString {
        let str = NSMutableAttributedString()
        str.append("    var ".purpleKeyWord)
        str.append("json = ".normalWord)
        str.append(String.dictionaryName)
        str.append("()\n".normalWord)
        return str
    }
    static func getVariableType(key: String) -> VariableType {
        var type = VariableType.int
        switch key {
        case "2":
            type = .string
            break
        case "3":
            type = .float
            break
        case "4":
            type = .double
            break
        case "5":
            type = .bool
            break
        default:
            type = .date
            break
        }
        return type
    }
}
let kBackSlashN = "\n"



class Variable: NSObject {
    var variableID: String = UUID.init().uuidString
    var nameOfClass: String = ""
    var name: String = ""
    var type: VariableType = .int
    var customTypeName = ""
    
    var shouldHaveSortMethod = false
    var shouldHaveFindFilterMethod = false
    var variableSecurity = CodeSecurity.publicVar
    
    var getVariableTypeName: String {
        var typeString = ""
        if type == .customClass {
            typeString = customTypeName
        }else {
            typeString = type.rawValue
        }
        return typeString
    }
    var declareVariable: String {
        return "    \(variableSecurity.rawValue) var \(name): \(getVariableTypeName)?\(kBackSlashN)"
    }
    
    var initMethodLineOfThisVariable: String {
        let sortMethodString = """
        if let jsonVariable = json[\(name)] as? \(getVariableTypeName){
        \(name) = jsonVariable
        }\(kBackSlashN)
        """
        return type == .date ? "" : sortMethodString
    }
    
    var mapMethodLineOfThisVariable: String {
        let sortMethodString = """
                json[\(name)] = \(name) as AnyObject\(kBackSlashN)
        """
        return sortMethodString
    }
    
    var sortMethod: String {
        let comment = "    ///This Method is used for sort Array of\(nameOfClass) by \(name)\(kBackSlashN)"
        var code = """
            func sort\(nameOfClass)sBy\(name.uppercased())(_ order: ComparisonResult) -> [\(nameOfClass)] {\(kBackSlashN)
                let sortedArray = self.sorted { (object1, object2) -> Bool in\(kBackSlashN)
                return object1.\(name).compare(object2.\(name)) == order\(kBackSlashN)
                }\(kBackSlashN)
                return sortedArray\(kBackSlashN)
            }\(kBackSlashN)
        """
        code = comment + code + kBackSlashN
        return code
    }
    
    var filterMethod: String {
        let comment = "    ///This Method is used for filter Array of\(nameOfClass) by \(name)\(kBackSlashN)"
        var code = """
            func filter\(nameOfClass)sBy\(name.uppercased())(_ \(name.uppercased()): \(getVariableTypeName) -> [\(nameOfClass)] {
                return self.filter({ (object) -> Bool in
                            return object.\(name) = \(name.uppercased())
                        })
            }\(kBackSlashN)
        """
        code = comment + code + kBackSlashN
        return code
    }
    var findMethod: String {
        let comment = "///This Method is used find object in Array of\(nameOfClass) by \(name)\(kBackSlashN)"
        var code = """
            func find\(nameOfClass)sBy\(name.uppercased())(_ \(name.uppercased()): \(getVariableTypeName) -> \(nameOfClass)? {
                return self.filter({ (object) -> Bool in
                            return object.\(name) = \(name.uppercased())
                        }).first
            }
        """
        code = comment + code + kBackSlashN
        return code
    }
    
    ///Mark: - Colofull Code Conversion
    var getAttributedVariableTypeName: NSAttributedString {
        var typeString = ""
        if type == .customClass {
            typeString = customTypeName
            return typeString.userdefineWord
        }else {
            typeString = type.rawValue
            return typeString.blueKeyWord
        }
    }
    var colorfullDeclareVariable: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append((kTapSpace + variableSecurity.rawValue).purpleKeyWord)
        mutableString.append(" var ".purpleKeyWord)
        mutableString.append("\(name): ".normalWord)
        mutableString.append(getAttributedVariableTypeName)
        mutableString.append("?\n".purpleKeyWord)
        return mutableString
    }
    var colorfullInitMethodLineOfThisVariable: NSMutableAttributedString {
        let ifLet = "\(kTapSpace)\(kTapSpace)if let ".purpleKeyWord
        let variableName = "jsonVariable = json[\"\(name)\"] ".normalWord
        let newLine = " {\n".normalWord
        let variableAssignment = "\(kTapSpace)\(kTapSpace)\(kTapSpace)\(name) = jsonVariable\n\(kTapSpace)\(kTapSpace)}\n".normalWord
        
        let mutableString = NSMutableAttributedString()
        mutableString.append(ifLet)
        mutableString.append(variableName)
        mutableString.append("as? ".purpleKeyWord)
        mutableString.append(getAttributedVariableTypeName)
        mutableString.append(newLine)
        mutableString.append(variableAssignment)
        
        return mutableString
    }
    var colorFullMapMethodLineOfThisVariable: NSMutableAttributedString {
        let jsonAssignment = "\(kTapSpace)\(kTapSpace)json[\(name)] = \(name) ".normalWord
        let anyObject = "as AnyObject\n".purpleKeyWord
        
        let mutableString = NSMutableAttributedString()
        mutableString.append(jsonAssignment)
        mutableString.append(anyObject)
        
        return mutableString
    }
    
}
