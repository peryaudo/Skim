//
//  EditFeedsController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/05.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class EditFeedsController: NSViewController {
    @IBOutlet var arrayController: NSArrayController!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        arrayController.managedObjectContext = appDelegate.persistentContainer.viewContext
        arrayController.fetch(nil)
    }
    
    @IBAction func cancelClickAction(_ sender: Any) {
        dismissViewController(self)
    }

    @IBAction func okClickAction(_ sender: Any) {
        dismissViewController(self)
    }
}
