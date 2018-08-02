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
        SelectedFeed.shared.observer = self
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
            return
        }
        arrayController.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.characters {
        case "j":
            arrayController.selectNext(self)
        case "k":
            arrayController.selectPrevious(self)
        case "v":
            articleDoubleClicked(self)
        default:
            ()
        }
    }

    @IBAction func articleDoubleClicked(_ sender: Any) {
        guard let selectedObjects = arrayController.selectedObjects else { return }
        guard let url = (selectedObjects[0] as? Article)?.url else { return }
        NSWorkspace.shared.open(url)
    }
    
}

extension FeedContentsController: SelectedFeedObserver {
    func onSelectedFeedChanged() {
        guard let feed = SelectedFeed.shared.feed else { return }
        arrayController.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        arrayController.fetchPredicate = NSPredicate(format: "feed == %@", feed)
        arrayController.fetch(nil)
        arrayController.setSelectionIndex(0)
    }
}
