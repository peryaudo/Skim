//
//  AddNewFeedController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class AddNewFeedController: NSViewController {
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func okClickedAction(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let feed = Feed(context: managedContext)
        feed.title = titleTextField.stringValue
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            let alert = NSAlert()
            alert.messageText = "Could not save: \(error)"
            alert.runModal()
        }
        
        dismissViewController(self)
    }
}
