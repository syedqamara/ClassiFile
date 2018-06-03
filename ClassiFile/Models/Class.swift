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
    var classID: String = UUID.init().uuidString
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
        code += kBackSlashN + "return json"
        code = code + "}" + kBackSlashN
        code.addMark(MarkType.jsonMapper)
        return code
    }
    
    var shouldCreateExtension: Bool {
        return (variables.haveAnySortMethodRequest || variables.haveAnyFilterFindMethodRequest)
    }
    
    func addVariable(name: String, variableType: VariableType, shouldHaveSort: Bool, shouldHaveFilter: Bool) {
        let variable = Variable()
        variable.name = name
        variable.type = variableType
        variable.shouldHaveSortMethod = shouldHaveSort
        variable.shouldHaveFindFilterMethod = shouldHaveFilter
        variables.append(variable)
    }
    
    /// Mark: - Colorfull Code Conversion
    var colorFullVariableInitialization: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        
        for variable in variables {
            mutableString.append(variable.colorfullDeclareVariable)
        }
        mutableString.append(kBackSlashN.normalWord)
        mutableString.append("".addColofullMark(MarkType.properties))
        return mutableString
    }
    var colorFullCompleteMappingMethod: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(("\n" + kBackSlashN).commentWord)
        mutableString.append("\(kTapSpace)public var ".purpleKeyWord)
        mutableString.append("jsonMap: ".normalWord)
        mutableString.append(String.dictionaryName)
        mutableString.append("{\n".normalWord)
        mutableString.append(Constant.colorfullJsonCreation)
        for variable in variables {
            mutableString.append(variable.colorFullMapMethodLineOfThisVariable)
        }
        mutableString.append("\(kTapSpace)\(kTapSpace)return ".purpleKeyWord)
        mutableString.append("json\n\(kTapSpace)}".normalWord)
        mutableString.append("".addColofullMark(.jsonMapper))
        return mutableString
    }
    var colorFullCompleteInitMethodCode: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(("\n" + kBackSlashN).commentWord)
        mutableString.append("\(kTapSpace)public init".purpleKeyWord)
        mutableString.append("(_ json: ".normalWord)
        mutableString.append(String.dictionaryName)
        mutableString.append("){\n".normalWord)
        for variable in variables {
            mutableString.append(variable.colorfullInitMethodLineOfThisVariable)
        }
        mutableString.append("\n\(kTapSpace)}".normalWord)
//        mutableString.append("".addColofullMark(.initializer))
        return mutableString
    }
    
    var colorfullCompleteClass: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(("//This is Automatic Created Model \(name)" + kBackSlashN).commentWord)
        mutableString.append("import ".purpleKeyWord)
        mutableString.append("Foundation\n\n".normalWord)
        mutableString.append("class ".purpleKeyWord)
        mutableString.append("\(name): ".normalWord)
        mutableString.append("NSObject".blueKeyWord)
        mutableString.append(" {\n".normalWord)
        
        mutableString.append("//Declare all variables for this class\n".commentWord)
        mutableString.append(colorFullVariableInitialization)
        mutableString.append("\n".normalWord)
        
        mutableString.append("//Declare and implement init(json: [String: AnyObject]) for this class".commentWord)
        mutableString.append(colorFullCompleteInitMethodCode)
        mutableString.append("\n".normalWord)
        
        mutableString.append("//Declare and implement map()-> [String: AnyObject]".commentWord)
        mutableString.append(colorFullCompleteMappingMethod)
        mutableString.append("\n".normalWord)
        
        mutableString.append("\n}".normalWord)
//        mutableString.append("".addColofullMark(.initializer))
        return mutableString
    }
}


