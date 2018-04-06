//
//  StoryboardHandler.swift
//  ClassiFile
//
//  Created by Syed Qamar Abbas on 06/04/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa
import SwiftyXMLParser
typealias XMLParseResult = (status: Bool, xml: XML.Accessor?)
class StoryboardHandler: NSObject {
    static let shared = StoryboardHandler()
    
    func parseXML(with xmlStr: String, completionHandler: @escaping (XMLParseResult)->() ) {
        let parse = XMLParser()
        do {
            let newXML = try XML.parse(xmlStr)
            completionHandler(XMLParseResult(true, newXML))
        }catch _ {
            completionHandler(XMLParseResult(false, nil))
        }
        
    }
    
}
