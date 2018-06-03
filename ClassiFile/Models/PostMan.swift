//
//  PostMan.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Cocoa

class PostMan: NSObject {
    var items : [PostmanItem]?
    
    init?(_ json:[String: AnyObject]) {
        items = PostmanItem.initialize(json)
        if items?.count == 0 {
            return nil
        }
    }
    
}
