//
//  FeedListController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class FeedListController: NSViewController {
    @IBOutlet var treeController: NSTreeController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        treeController.managedObjectContext = appDelegate.persistentContainer.viewContext
        treeController.fetch(nil)
    }
    
    @IBAction func feedSelectedAction(_ sender: Any) {
        let selectedObjects = treeController.selectedObjects
        if selectedObjects.isEmpty {
            return
        }
        guard let feed = selectedObjects[0] as? Feed else { return }
        SelectedFeed.shared.feed = feed
    }
}
