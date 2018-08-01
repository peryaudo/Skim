//
//  FeedContentsController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class FeedContentsController: NSViewController {
    @IBOutlet var arrayController: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        arrayController.managedObjectContext = appDelegate.persistentContainer.viewContext
        arrayController.fetch(nil)
    }
    
    @IBAction func articleDoubleClicked(_ sender: Any) {
        guard let selectedObjects = arrayController.selectedObjects else { return }
        guard let url = (selectedObjects[0] as? Article)?.url else { return }
        NSWorkspace.shared.open(url)
    }
}
