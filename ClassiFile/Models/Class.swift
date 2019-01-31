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
    var parentClass: Class?
    var isBaseClass = false
    ///Contains complete code for your class as string
    init(with cName: String) {
        super.init()
        self.name = cName
    }
    override var completeClass: String? {
        if parentClass == nil {
           parentClass = Class(with: "Mappable")
        }
        //create class
        var code = """
        //This is Automatic Created Model \(name)
        
        import Foundation
        import ObjectMapper
        
        """
        code = code + "class \(name): \(parentClass!.name) {" + kBackSlashN
        
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
        let initMethod = """
        required init?(map: Map){
        
        }

        """
        code += initMethod
        
        code = code + "func mapping(map: Map) {\(kBackSlashN)"
        for variable in variables {
            code = code + variable.initMethodLineOfThisVariable
        }
        if parentClass!.name != "Mappable" {
            
        }
        code = code + "}" + kBackSlashN
        code.addMark(MarkType.initializer)
        return code
    }
    
    var completeMappingMethod: String {
//        var code = "///Get json for you class" + kBackSlashN
//        code = code + "public var jsonMap: [String: AnyObject]{" + kBackSlashN
//        code = code + Constant.jsonCreation + kBackSlashN
//        for variable in variables {
//            code = code + variable.mapMethodLineOfThisVariable
//        }
//        code += kBackSlashN + "return json\n"
//        code = code + "}" + kBackSlashN
//        code.addMark(MarkType.jsonMapper)
        return ""
    }
    
    var shouldCreateExtension: Bool {
        return false//(variables.haveAnySortMethodRequest || variables.haveAnyFilterFindMethodRequest)
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
//        mutableString.append(("\n" + kBackSlashN).commentWord)
//        mutableString.append("\(kTapSpace)public var ".purpleKeyWord)
//        mutableString.append("jsonMap: ".normalWord)
//        mutableString.append(String.dictionaryName)
//        mutableString.append("{\n".normalWord)
//        mutableString.append(Constant.colorfullJsonCreation)
//        for variable in variables {
//            mutableString.append(variable.colorFullMapMethodLineOfThisVariable)
//        }
//        mutableString.append("\(kTapSpace)\(kTapSpace)return ".purpleKeyWord)
//        mutableString.append("json\n\(kTapSpace)}".normalWord)
//        mutableString.append("".addColofullMark(.jsonMapper))
        return mutableString
    }
    var colorFullCompleteInitMethodCode: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(("\n" + kBackSlashN).commentWord)
        mutableString.append("\(kTapSpace)public func".purpleKeyWord)
        mutableString.append(" mapping(map: ".whiteDefineWord)
        mutableString.append("Map".userdefineWord)
        mutableString.append("){\n".whiteDefineWord)
        for variable in variables {
            mutableString.append(variable.colorfullInitMethodLineOfThisVariable)
        }
        mutableString.append("\n\(kTapSpace)}".whiteDefineWord)
//        mutableString.append("".addColofullMark(.initializer))
        return mutableString
    }
    
    var colorfullCompleteClass: NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        if let classCode = completeClass {
            mutableString.append(classCode.normalWord)
        }
        if let classCode = completeClass {
            for keyword in languageStaticKeyWords {
                let ranges = classCode.ranges(of: keyword)
                for range in ranges {
                    let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: NSColor.purpleCodeColor, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 16, weight: .regular)]
                    let newRange = NSRange.init(range, in: classCode)
                    mutableString.addAttributes(attr, range: newRange)
                }
            }
            for keyword in languageDataTypeKeyWords {
                let ranges = classCode.ranges(of: keyword)
                for range in ranges {
                    let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: NSColor.blueCodeColor, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 16, weight: .regular)]
                    let newRange = NSRange.init(range, in: classCode)
                    mutableString.addAttributes(attr, range: newRange)
                }
            }
            for variable in variables {
                if variable.type == .customClass {
                    let ranges = classCode.ranges(of: variable.getVariableTypeName)
                    for range in ranges {
                        let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: NSColor.userdefineCodeColor, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 16, weight: .regular)]
                        let newRange = NSRange.init(range, in: classCode)
                        mutableString.addAttributes(attr, range: newRange)
                    }
                }
            }
        }
        return mutableString
    }
    
    var languageStaticKeyWords: [String] {
        var keyWords = [String]()
        keyWords = ["var ","if ","let ","for ","else ","class ","func ","private ","public ","fileprivate ","init ","return ","break ","continue ","self ", " Any ", "?", " as ", "as?"]
        return keyWords
    }
    var languageDataTypeKeyWords: [String] {
        var keyWords = [String]()
        keyWords = ["String","Int","Bool","Float","Double","Void","AnyObject"]
        return keyWords
    }
    
    
    
}


