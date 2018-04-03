//
//  Variable+AddVariable.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

enum MarkType: String {
    case initializer = "Initializer"
    case properties = "Properties"
    case jsonMapper = "Mapper"
    case sorter = "SortBy"
    case finder = "FindBy"
    case filterer = "FilterBy"
}

class Class: File {
    var variables = [Variable]()
    
    ///Contains complete code for your class as string
    override var completeClass: String? {
        //create class
        var code = """
        //This is Automatic Created Model \(name)
        
        import Foundation
        
        
        """
        code = code + "class \(name): NSObject {" + kBackSlashN
        
        //Declare all variables for this class
        code = code + variableInitialization + kBackSlashN
        
        //Declare and implement init(json: [String: AnyObject]) for this class
        code = code + completeInitMethodCode + kBackSlashN
        
        //Declare and implement map()-> [String: AnyObject]
        code = code + completeMappingMethod + kBackSlashN
        
        //Terminate class
        code = code + "}" + kBackSlashN
        
        return code + kBackSlashN
    }
    
    
    var variableInitialization: String {
        var code = ""
        for variable in variables {
            code = code + variable.declareVariable
        }
        code = code + kBackSlashN
        code.addMark(MarkType.properties)
        return code
    }
    
    
    var completeInitMethodCode: String {
        var code = "///Initialize \(name) with json" + kBackSlashN
        code = code + "public init(_ json: [String: AnyObject]){\(kBackSlashN)"
        for variable in variables {
            code = code + variable.initMethodLineOfThisVariable
        }
        code = code + "}" + kBackSlashN
        code.addMark(MarkType.initializer)
        return code
    }
    
    var completeMappingMethod: String {
        var code = "///Get json for you class" + kBackSlashN
        code = code + "public var jsonMap: [String: AnyObject]{" + kBackSlashN
        code = code + Constant.jsonCreation + kBackSlashN
        for variable in variables {
            code = code + variable.mapMethodLineOfThisVariable
        }
        code = code + "}" + kBackSlashN
        code.addMark(MarkType.jsonMapper)
        return code
    }
    
    
    
    var shouldCreateExtension: Bool {
        return (variables.haveAnySortMethodRequest || variables.haveAnyFilterFindMethodRequest)
    }
    
    func addVariable(_ name: String, _ type: VariableType, _ shouldSort: Bool, _ shouldFilter: Bool) {
        let variable = Variable()
        variable.name = name
        variable.type = type
        variable.shouldHaveSortMethod = shouldSort
        variable.shouldHaveFindFilterMethod = shouldFilter
        variables.append(variable)
    }
    
}


