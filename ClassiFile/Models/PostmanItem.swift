//
//  PostmanItem.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Foundation

class PostmanItem: NSObject {
    var name: String?
    var request: PostmanRequest?
    init(_ json: [String: AnyObject]) {
        name = json["name"] as? String
        if let requestJson = json["request"] as? [String: AnyObject] {
            request = PostmanRequest(requestJson)
        }
    }
    class func initialize(_ json: [String: AnyObject]) -> [PostmanItem] {
        var headers = [PostmanItem]()
        if let jsonArray = json["item"] as? [[String: AnyObject]] {
            for js in jsonArray {
                let header = PostmanItem(js)
                headers.append(header)
            }
        }
        return headers
    }
    
    var getReadymadeRequest : URLRequest? {
        guard let urlString = self.request?.url?.url else {return nil}
        guard let url = URL.init(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        if let method = request?.method {
            urlRequest.httpMethod = method.rawValue
        }
        if let headers = request?.header {
            urlRequest.headerParam = headers.embedAllIntoDictionary
        }
        if let query = request?.url?.query {
            urlRequest.headerParam = query.embedAllIntoDictionary
        }
        if let body = request?.body {
            urlRequest.httpBody = body.bodyData
        }
        return urlRequest
    }
}
