//
//  Variable+Array.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

extension Array where Element: Class {
    func findIndex(_ classObj: Class) -> Int {
        var index = 0
        for c in self {
            if c.classID == classObj.classID {
                return index
            }
            index += 1
        }
        return -1
    }
    func updateClassName(_ oldName: String, className: String, _ index: Int) {
        self[index].name = className
        for classObj in self {
            for variable in classObj.variables {
                if variable.getVariableTypeName == oldName {
                    variable.customTypeName = className
                }
            }
        }
    }
}

extension Array where Element: Variable {
    var haveAnyFilterFindMethodRequest: Bool {
        return variablesWithFilterFindMethodReqeust.count > 0
    }
    var haveAnySortMethodRequest: Bool {
        return variablesWithSortMethodReqeust.count > 0
    }
    var variablesWithFilterFindMethodReqeust: [Variable] {
        return self.filter({ (variable) -> Bool in
            return variable.shouldHaveFindFilterMethod
        })
    }
    var variablesWithSortMethodReqeust: [Variable] {
        return self.filter({ (variable) -> Bool in
            return variable.shouldHaveSortMethod
        })
    }
    func findVariableByID(_ id: String) -> Variable? {
        return self.filter({ (variable) -> Bool in
            return variable.variableID == id
        }).first
    }
}
/*
 
 */
