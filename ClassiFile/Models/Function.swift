//
//  Function.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class Function: NSObject {
    var name: String = ""
    var security = CodeSecurity.publicVar
    var returnType = VariableType.void
    var params = [Parameter]()
    var comment: String = "///This is default comment string" + kBackSlashN
    var insideCode: String = ""
    var completeCode: String {
        var code = "func \(name)\(params.completeParamString) -> \(returnType.rawValue) {"
        code = comment + code
        code += insideCode
        code += "}" + kBackSlashN
        return ""
    }
    
    
}

class BuiltInFunction: Function {
    
}
class CustomFunction: Function {
    
}
