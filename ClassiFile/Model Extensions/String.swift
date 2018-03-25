//
//  String.swift
//  Swiftify
//
//  Created by Syed Qamar Abbas on 25/03/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

extension String {
    mutating func addMark(_ typeName: MarkType) {
        let markString = "//MARK: - \(typeName.rawValue)" + kBackSlashN
        self = markString + self
    }
}
