//
//  WindowController.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/01.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!

    var loadingCount: Int = 0

    override func windowDidLoad() {
        super.windowDidLoad()
    
        loadingSpinner.isHidden = true
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

        loadingCount = feeds.count
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(self)

        for feed in feeds {
            feed.retrieveFromUrl() {
                self.loadingCount -= 1
                self.loadingSpinner.stopAnimation(self)
                self.loadingSpinner.isHidden = true
            }
        }
    }
}
