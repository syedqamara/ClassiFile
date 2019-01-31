//
//  Extension.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class Extension: File {
    var classRef: Class?
    var classNameObject = ""
    init(with classObj: Class) {
        super.init()
        classRef = classObj
        classNameObject = classObj.name
        name = "\(classObj.name)+Utility"
    }
    
    override var completeClass: String? {
        if let classObj = classRef {
            var code = "extension Array where Element: \(classObj.name) {" + kBackSlashN
            
            if let method = allFilterMethods {
                code = code + method + kBackSlashN
            }
            if let method = allFindMethods {
                code = code + method + kBackSlashN
            }
            if let method = allSortMethods {
                code = code + method + kBackSlashN
            }
            code = code + "}" + kBackSlashN
            return code
        }
        return nil
    }
    
    var allFilterMethods: String? {
        if let classObj = classRef {
            let variables = classObj.variables.variablesWithFilterFindMethodReqeust
            var code = "\n"
            for variable in variables {
                variable.nameOfClass = self.classNameObject
                code = code + variable.filterMethod + kBackSlashN
            }
            code = code + kBackSlashN
            code.addMark(.filterer)
            return code
        }
        return nil
    }
    var allFindMethods: String? {
        if let classObj = classRef {
            let variables = classObj.variables.variablesWithFilterFindMethodReqeust
            var code = "\n"
            for variable in variables {
                variable.nameOfClass = self.classNameObject
                code = code + variable.findMethod + kBackSlashN
            }
            code = code + kBackSlashN
            code.addMark(.finder)
            return code
        }
        return nil
    }
    var allSortMethods: String? {
        if let classObj = classRef {
            let variables = classObj.variables.variablesWithSortMethodReqeust
            var code = "\n"
            for variable in variables {
                variable.nameOfClass = self.classNameObject
                code = code + variable.sortMethod + kBackSlashN
            }
            code = code + kBackSlashN
            code.addMark(.sorter)
            return code
        }
        return nil
    }
    
    
    
}
