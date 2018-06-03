//
//  Body.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Foundation

class Body: NSObject {
    var mode = PostmanModeType.none
    var params: BodyParams?
    var paramArray: [BodyParams]?
    
    init(_ json: [String: AnyObject]) {
        if let modeStr = json["mode"] as? String, let raw = PostmanModeType(rawValue:modeStr ) {
            mode = raw
        }
        if let param = json[mode.rawValue] as? [String : AnyObject] {
            params = BodyParams(param)
        }
        if let param = json[mode.rawValue] as? [[String : AnyObject]] {
            if param.count > 0 {
                paramArray = []
            }
            for p in param {
                let paramObj = BodyParams(p)
                paramArray?.append(paramObj)
            }
        }
    }
    var bodyStr: String {
        if let param = paramArray {
            let dict = param.embedAllIntoDictionary
            var data = [String]()
            for(key, value) in dict
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }
        return ""
    }
    var bodyData: Data? {
        if mode == .formData || mode == .formdata {
            return bodyStr.data(using: .utf8)
        }
        if let param = paramArray {
            let dict = param.embedAllIntoDictionary
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
        return nil
    }
}

class BodyParams: KeyValuePair {
    var type: String?
    
    override init(_ json: [String : AnyObject]) {
        type = json["type"] as? String
        super.init(json)
    }
}
