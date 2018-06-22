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
    func findVariableIndex(_ variable: Variable) -> Int {
        var index = 0
        for c in self {
            if c.variables.findVariableIndex(variable) != -1 {
                return index
            }
            index += 1
        }
        return -1
    }
    func getIndexPathOfVariable(_ variable: Variable) -> IndexPath? {
        let sectionIndex = self.findVariableIndex(variable)
        if sectionIndex != -1 {
            let index = self[sectionIndex].variables.findVariableIndex(variable)
            if index != -1 {
                let indexPath = IndexPath(item: index, section: sectionIndex)
                return indexPath
            }
        }
        return nil
    }
    func updateVariable(_ variable: Variable) {
        let sectionIndex = self.findVariableIndex(variable)
        if sectionIndex != -1 {
            let index = self[sectionIndex].variables.findVariableIndex(variable)
            if index != -1 {
                self[sectionIndex].variables[index] = variable
            }
        }
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
    func findVariableIndex(_ variable: Variable) -> Int {
        var index = 0
        for c in self {
            if c.variableID == variable.variableID {
                return index
            }
            index += 1
        }
        return -1
    }
    func haveSameVariables(_ classObj: Class) -> Bool {
        var isSame = true
        for variable in self {
            var isSameVariable = false
            for cVariable in classObj.variables {
                if cVariable.isSameVariable(variable) {
                    isSameVariable = true
                    break
                }
            }
            if isSameVariable == false {
                isSame = false
                break
            }
        }
        return isSame
    }
}
/*
 
 */
