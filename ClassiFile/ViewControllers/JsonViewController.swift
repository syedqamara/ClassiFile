//
//  JsonViewController.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/8/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class JsonViewController: PostmanJsonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func loadModelWithJSON(json: Any) {
        if let object = json as? [String: Any] {
            PostManRequestManager.shared.createClassWithJson(json: object)
        }
        else if let object = json as? [Any] {
            if let jsonArray = object.first as? [String: Any] {
                PostManRequestManager.shared.createClassWithJson(json: jsonArray)
            }
        }
    }
}
