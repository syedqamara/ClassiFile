//
//  PostManRequestManager.swift
//  PostManiOS
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 Syed Hasnain. All rights reserved.
//

import Cocoa



class PostManRequestManager: NSObject {
    static var shared = PostManRequestManager()
    
    var postman: PostMan?
    var classes = [Class]()
    func callAPI(completion: @escaping(Any?)->()) {
        if let request = postman?.items?.first?.getReadymadeRequest {
            Request.shared.dataTask(request: request) { (object, error) in
                if let json = object as? [String: Any] {
                    self.createClassWithJson(json: json)
                    
                }
                else if let json = object as? [Any] {
                    if let jsonArray = json.first as? [String: Any] {
                        self.createClassWithJson(json: jsonArray)
                    }
                }
                if let anyObj = object {
                    completion(anyObj)
                }
                else if let err = error {
                    completion(nil)
                    DispatchQueue.main.async {
                        self.showErrorDialogIn(title: "Error", message: err)
                    }
                }
            }
        }
        else {
            completion(nil)
        }
    }
    func createClassWithJson(json: [String: Any]) {
        classes = []
        _ = parseJson(json: json, className: "MasterClass")
        print("Successfully Created Class")
    }
    func addClassVariable(key: String, classObj: Class, isArray: Bool = false) {
        let variable = Variable()
        variable.isArrayType = isArray
        variable.name = "\(key.lowercased())"
        variable.keyName = key
        variable.type = .customClass
        variable.customTypeName = key.capitalClassName
        variable.shouldHaveSortMethod = false
        variable.shouldHaveSortMethod = false
        classObj.variables.append(variable)
    }
    func parseJson(json: [String: Any], className: String) -> Class {
        let newClass = Class(with: "NSObject")
        newClass.name = className
        classes.append(newClass)
        for (key, value) in json {
            var jsonValue = value
            var variableIsArray = false
            if let isJson = value as? [String: Any] {
                let returnedClass = parseJson(json: isJson, className: key.capitalClassName)
                addClassVariable(key: key, classObj: newClass)
                continue
            }
            if let isArray = value as? [Any] {
                if let isJson = isArray.first as? [String: Any] {
                    let returnedClass = parseJson(json: isJson, className: key.capitalClassName)
                    addClassVariable(key: key, classObj: newClass, isArray: true)
                    continue
                }else {
                    jsonValue = isArray.first
                    variableIsArray = true
                }
            }
            var type = VariableType.string
            if let isBool = jsonValue as? Bool {
                type = VariableType.bool
                print("Key    : \(key)\n")
                print("Value  : \(isBool)\n")
            }
            else if let isDouble = jsonValue as? Double {
                type = VariableType.double
                print("Key    : \(key)\n")
                print("Value  : \(isDouble)\n")
            }
            else if let isInt = jsonValue as? Int {
                type = VariableType.int
                print("Key    : \(key)\n")
                print("Value  : \(isInt)\n")
            }
            else if let isString = jsonValue as? String {
                type = VariableType.string
                print("Key    : \(key)\n")
                print("Value  : \(isString)\n")
            }
            
            newClass.addVariable(name: key, variableType: type, shouldHaveSort: false, shouldHaveFilter: true)
            newClass.variables[newClass.variables.count-1].isArrayType = variableIsArray
            newClass.variables[newClass.variables.count-1].keyName = key
        }
        return newClass
    }
    func save(completion: @escaping ()->()) {
        // 2
        let panel = NSSavePanel()
        // 3
        panel.directoryURL = URL(string: "~/Documents/")!
        // 4
        // 5
        let result = panel.runModal()
        if result == NSApplication.ModalResponse.OK,
            let url = panel.url {
            // 6
            do {
                for classObj in self.classes {
                    var urlString = url.deletingLastPathComponent().absoluteString
                    urlString += classObj.name + ".swift"
                    if let classUrl = URL(string: urlString) {
                        try classObj.completeClass!.write(to: classUrl, atomically: true, encoding: .utf8)
                    }
                    urlString = url.deletingLastPathComponent().absoluteString
                    
                    let fileExtension = Extension(with: classObj)
                    urlString += fileExtension.name + ".swift"
                    if let extensionUrl = URL(string: urlString) {
                        fileExtension.save()
                        try fileExtension.completeClass!.write(to: extensionUrl, atomically: true, encoding: .utf8)
                    }
                }
                completion()
                
            } catch {
                self.showErrorDialogIn(title: "Unable to save file",
                                       message: error.localizedDescription)
            }
        }
    }
    func isSameClass(_ classObj: Class) -> [Class] {
        let filterClass = self.classes.filter { (classObject) -> Bool in
            return classObject.variables.haveSameVariables(classObj) && classObj.classID != classObject.classID
        }
        return filterClass.filter({$0.classID != classObj.classID})
    }
    func haveClass(_ classObj: Class) -> [Class] {
        let filterClass = self.classes.filter { (classObject) -> Bool in
            return classObject.variables.haveSameVariables(classObj)
        }
        return filterClass.filter({$0.isBaseClass})
    }
    func isConformToInheritance(_ classObj: Class) -> [Class] {
        let filterClass = self.classes.filter { (classObject) -> Bool in
            return classObject.variables.matchingVariableCounts(classObj) >= 3 && classObj.classID != classObject.classID
        }
        return filterClass.filter({$0.classID != classObj.classID})
    }
    func createBaseClass(for classObj: Class) {
        if let baseClass = getBaseClass(of: classObj), let index = classes.index(of: classObj) {
            baseClass.name = "Base\(classObj.name)"
            let remainingVariablesAfterBaseClassGeneration = classObj.variables.filter({ (variable) -> Bool in
                return !baseClass.variables.haveVariable(variable)
            })
            baseClass.isBaseClass = true
            if haveClass(baseClass).count == 0 {
                self.classes.append(baseClass)
                self.classes[index].parentClass = baseClass
            }else {
                self.classes[index].parentClass = haveClass(baseClass).first
            }
            self.classes[index].variables = remainingVariablesAfterBaseClassGeneration
        }
    }
    func getBaseClass(of classObj: Class) -> Class? {
        var baseClass: Class?
        let matchedClasses = isConformToInheritance(classObj)
        if let matchedClass = matchedClasses.first {
            let commonVariables = matchedClass.variables.getMatchingVariables(classObj: classObj)
            let newClass = Class(with: "NSObject")
            newClass.variables = commonVariables
            baseClass = newClass
        }
        return baseClass
    }
    func showErrorDialogIn(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.runModal()
    }
}
