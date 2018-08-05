//
//  EditFeedsController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/05.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class EditFeedsController: NSViewController {
    @IBOutlet var feedsController: NSArrayController!
    @IBOutlet var folderController: NSArrayController!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        feedsController.managedObjectContext = appDelegate.persistentContainer.viewContext
        feedsController.fetch(nil)
        folderController.managedObjectContext = appDelegate.persistentContainer.viewContext
        folderController.fetch(nil)
    }
    
    @IBAction func cancelClickAction(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.persistentContainer.viewContext.rollback()
        dismissViewController(self)
    }

    @IBAction func okClickAction(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        do {
            try appDelegate.persistentContainer.viewContext.save()
            dismissViewController(self)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Cannot save"
            alert.runModal()
        }
    }
}
