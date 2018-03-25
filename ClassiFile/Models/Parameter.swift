//
//  Parameter.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class Parameter: Variable {
    var paramDescription: String = "_"
    var completeCode: String {
        return paramDescription + " " + name + ": " + type.rawValue
    }
}
extension Array where Element: Parameter {
    var completeParamString: String {
        var code = "("
        for param in self {
            code = code + param.completeCode
            if let last = self.last, last != param {
                code += ", "
            }
        }
        code += ")"
        return code
    }
}
