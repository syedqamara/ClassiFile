//
//  PostmanRequest.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Cocoa

class PostmanURL: NSObject {
    var query: [KeyValuePair]?
    var url: String?
    init(_ json: [String: AnyObject]) {
        query = KeyValuePair.initialize(json, "query")
        url = json["raw"] as? String
    }
}

class PostmanRequest: NSObject {
    var method = RequestType.get
    var header: [KeyValuePair]?
    var body: Body?
    var url: PostmanURL?
    
    init(_ json: [String: AnyObject]) {
        if let methodStr = json["method"] as? String, let type = RequestType(rawValue: methodStr) {
            method = type
        }
        header = KeyValuePair.initialize(json,"header")
        if let bodyjson = json["body"] as? [String: AnyObject] {
            body = Body(bodyjson)
        }
        if let urljson = json["url"] as? [String: AnyObject] {
            url = PostmanURL(urljson)
        }
    }
    
    
}
