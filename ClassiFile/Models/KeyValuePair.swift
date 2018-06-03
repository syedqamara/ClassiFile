//
//  Header.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Foundation

class KeyValuePair: NSObject {
    var key: String?
    var value: String?
    init(_ json: [String: AnyObject]) {
        key = json["key"] as? String
        value = json["value"] as? String
    }
    var toJSON: [String: String] {
        var dict = [String: String]()
        dict["key"] = key
        dict["value"] = value
        return dict
    }
    class func initialize(_ json: [String: AnyObject], _ key: String) -> [KeyValuePair] {
        var headers = [KeyValuePair]()
        if let jsonArray = json[key] as? [[String: AnyObject]] {
            for js in jsonArray {
                let header = KeyValuePair(js)
                headers.append(header)
            }
        }
        return headers
    }
}
extension Array where Element: KeyValuePair {
    var embedAllIntoDictionary: [String: String] {
        var headers = [String: String]()
        for header in self {
            if let key = header.key, let value = header.value {
                headers[key] = value
            }
        }
        return headers
    }
}
