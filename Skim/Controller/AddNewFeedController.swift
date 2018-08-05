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
    @IBOutlet weak var folderComboBox: NSComboBox!
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        var folderNames: [String] = []
        
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        managedContext.performAndWait {
            let folders = try! request.execute()
            folderNames = folders.map({ (folder) -> String in
                return folder.title!
            })
        }
        
        folderComboBox.addItems(withObjectValues: folderNames)
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
        folder.title = folderComboBox.stringValue

        let feed = Feed(context: managedContext)
        feed.url = url
        feed.folder = folder
        feed.title = "Untitled"

        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
            let alert = NSAlert()
            alert.messageText = "Cannot save"
            alert.runModal()
            return
        }
        
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(self)
        
        feed.retrieveFromUrl {
            self.loadingSpinner.isHidden = true
            self.loadingSpinner.stopAnimation(self)
            self.titleTextField.stringValue = feed.title!
            (NSApplication.shared.delegate! as! AppDelegate).updateUnreadCountBadge()
            self.dismissViewController(self)
        }
    }
}
