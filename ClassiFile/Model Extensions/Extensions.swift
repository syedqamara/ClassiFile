//
//  Extensions.swift
//  PostMan
//
//  Created by Syed Qamar Abbas on 5/14/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import Cocoa

extension NSWindow {
    open override func keyUp(with event: NSEvent) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WindowKeyEventFire"), object: event)
    }
}

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
extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
}
extension NSRange {
    init(_ range: Range<String.Index>, in string: String) {
        self.init()
        guard let startIndex = range.lowerBound.samePosition(in: string.utf16) else {return}
        guard let endIndex = range.upperBound.samePosition(in: string.utf16) else {return}
        self.location = string.distance(from: string.startIndex,
                                        to: range.lowerBound)
        self.length = string.distance(from: startIndex , to: endIndex)
    }
}
extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.characters.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
}
