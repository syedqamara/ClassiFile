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
    var path: String = "~/Documents/"
    var completeClass: String? {
        return nil
    }
    var fullFileName: String {
        return name + ".swift"
    }
    var localURL: URL?
    func save() {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathExtension(fullFileName)
                FileManager.default.createFile(atPath: fileURL.lastPathComponent, contents: nil, attributes: nil)
                if let fileData = completeClass {
                    try fileData.write(to: fileURL, atomically: false, encoding: .utf8)
                    localURL = fileURL
                }
            }
        } catch {
            print("error:", error)
        }
    }
}
