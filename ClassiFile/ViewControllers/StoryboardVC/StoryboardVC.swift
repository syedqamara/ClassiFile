//
//  StoryboardVC.swift
//  ClassiFile
//
//  Created by Syed Qamar Abbas on 06/04/2018.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class StoryboardVC: NSViewController {
    @IBOutlet weak var textView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func didTapParseButton(_ sender: Any) {
        let demoStoryboard = """
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="13142" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
                <dependencies>
                    <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="12042"/>
                </dependencies>
            <scenes/>
        </document>
        """
        
    }
}
