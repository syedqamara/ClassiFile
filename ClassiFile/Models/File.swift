//
//  File.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class File: NSObject {
    var name: String = ""
    var path: String{
//        return getFileFirstTowName + "Documents/"
        return "~/Documents/"
    }
    var completeClass: String? {
        return nil
    }
    var fullFileName: String {
        return "" + name + ".swift"
    }
    var localURL: URL?
    func save() {
        let fileURLString = path + fullFileName
        let fileURL = URL(string: fileURLString)!
        localURL = fileURL
    }
    var getFileFirstTowName: String {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var arrayOfNames = documentDirectory.absoluteString.replacingOccurrences(of: "file:///", with: "").components(separatedBy: "/")
            if let firstName = arrayOfNames.first {
                arrayOfNames.removeFirst()
                if let secondName = arrayOfNames.first {
                    return "file:///" + firstName + "/" + secondName + "/"
                }
            }
        }
        return ""
    }
}
