//
//  Variable+Array.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

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
