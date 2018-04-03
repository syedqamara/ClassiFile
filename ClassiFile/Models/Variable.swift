//
//  Variable.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class Constant {
    static let jsonCreation = "    var json = [String: AnyObject]()"
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
    var shouldHaveSortMethod = false
    var shouldHaveFindFilterMethod = false
    var variableSecurity = CodeSecurity.publicVar
    
    
    var declareVariable: String {
        return "    \(variableSecurity.rawValue) var \(name): \(type.rawValue)?\(kBackSlashN)"
    }

    
    var initMethodLineOfThisVariable: String {
        let sortMethodString = """
            if let jsonVariable = json[\(name)] as? \(type.rawValue){
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
            func filter\(nameOfClass)sBy\(name.uppercased())(_ \(name.uppercased()): \(type.rawValue) -> [\(nameOfClass)] {
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
            func find\(nameOfClass)sBy\(name.uppercased())(_ \(name.uppercased()): \(type.rawValue) -> \(nameOfClass)? {
                return self.filter({ (object) -> Bool in
                            return object.\(name) = \(name.uppercased())
                        }).first
            }
        """
        code = comment + code + kBackSlashN
        return code
    }
}
