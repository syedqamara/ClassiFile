//
//  Extensions.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Cocoa

extension String {
    var toDict: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
extension Dictionary {
    var jsonStr: String {
        var str = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let tempStr = String.init(data: data, encoding: .utf8) {
                str = tempStr
            }
        }
        return str
    }
}
