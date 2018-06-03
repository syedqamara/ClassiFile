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
    func callAPI(completion: @escaping(Any)->()) {
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
            }
        }
    }
    func createClassWithJson(json: [String: Any]) {
        classes = []
        _ = parseJson(json: json, className: "MasterClass")
        print("Successfully Created Class")
    }
    func addClassVariable(key: String, classObj: Class) {
        let variable = Variable()
        variable.name = "\(key.lowercased())obj"
        variable.type = .customClass
        variable.customTypeName = key.uppercased()
        variable.shouldHaveSortMethod = false
        variable.shouldHaveSortMethod = false
        classObj.variables.append(variable)
    }
    func parseJson(json: [String: Any], className: String) -> Class {
        let newClass = Class()
        newClass.name = className
        classes.append(newClass)
        for (key, value) in json {
            var jsonValue = value
            if let isJson = value as? [String: Any] {
                let returnedClass = parseJson(json: isJson, className: key.uppercased())
                addClassVariable(key: key, classObj: newClass)
                continue
            }
            if let isArray = value as? [Any] {
                if let isJson = isArray.first as? [String: Any] {
                    let returnedClass = parseJson(json: isJson, className: key.uppercased())
                    addClassVariable(key: key, classObj: newClass)
                    continue
                }else {
                    jsonValue = isArray.first
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
        }
        return newClass
    }

}
