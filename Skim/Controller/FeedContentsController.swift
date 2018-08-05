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
    @IBOutlet weak var articleTableView: FeedContentsTableView!
    
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
            DispatchQueue.main.async {
                self.articleTableView.scrollSelectedToVisibleWithAnimation()
            }
        case "k":
            arrayController.selectPrevious(self)
            DispatchQueue.main.async {
                self.articleTableView.scrollSelectedToVisibleWithAnimation()
            }
        case "v":
            articleDoubleClicked(self)
        case "a":
            fallthrough
        case "s":
            let splitView = view.superview?.superview as? NSSplitView
            view.window?.makeFirstResponder(splitView?.arrangedSubviews.first?.subviews.first)
        default:
            ()
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
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
        feed.markArticlesAsShown()

        arrayController.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        arrayController.fetchPredicate = NSPredicate(format: "feed == %@", feed)
        arrayController.fetch(nil)
        arrayController.setSelectionIndex(0)
        DispatchQueue.main.async {
            self.articleTableView.scrollSelectedToVisibleWithAnimation()
        }
    }
}
