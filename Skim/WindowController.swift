//
//  WindowController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var feeds: [Feed] = []
        
        let request: NSFetchRequest<Feed> = Feed.fetchRequest()
        managedContext.performAndWait {
            feeds = try! request.execute()
        }
                
        for feed in feeds {
            feed.retrieveFromUrl()
        }
    }
}
