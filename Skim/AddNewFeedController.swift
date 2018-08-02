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
        guard let url = URL(string: urlTextField.stringValue) else {
            let alert = NSAlert()
            alert.messageText = "The URL was not valid"
            alert.runModal()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let folder = Folder(context: managedContext)
        folder.title = "Untitled"

        let feed = Feed(context: managedContext)
        feed.url = url
        feed.folder = folder

        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
            let alert = NSAlert()
            alert.messageText = "Cannot save"
            alert.runModal()
        }

        dismissViewController(self)
    }
}
