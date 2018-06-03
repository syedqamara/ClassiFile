//
//  PostmanJsonViewController.swift
//  ClassiFile
//
//  Created by Syed Hasnain on 6/3/18.
//  Copyright © 2018 QamarAbbas. All rights reserved.
//

import Cocoa

class PostmanJsonViewController: NSViewController {

    var postman: PostMan?
    @IBOutlet weak var textView: NSTextView!
    
    var hideHUD: Void {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    func showResponse(_ json: [String: AnyObject]) {
        DispatchQueue.main.async {
            self.textView.string = json.jsonStr
        }
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?._rawValue == "class" {
            let destVC = segue.destinationController as! ClassesViewController
            destVC.feeds = PostManRequestManager.shared.classes
        }
    }
    @IBAction func didTapGenerateButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let jsonStr = textView.string
        if let data = jsonStr.data(using: .utf8) {
            if let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as? [String: AnyObject] {
                self.postman = PostMan.init(json)
                PostManRequestManager.shared.postman = postman
                PostManRequestManager.shared.callAPI(completion: { (response) in
                    if let json = response as? [String: AnyObject] {
                        self.showResponse(json)
                    }
                    if let jsonArray = response as? [[String: AnyObject]], let json = jsonArray.first {
                        self.showResponse(json)
                    }
                    self.hideHUD
                    if PostManRequestManager.shared.classes.count > 0 {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "class"), sender: nil)
                            self.dismissViewController(self)
                        }
                    }
                })
                return
            }
        }
        self.hideHUD
    }
    
}
