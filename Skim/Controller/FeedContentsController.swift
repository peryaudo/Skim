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
    
    @IBAction func articleDoubleClicked(_ sender: Any) {
        guard let selectedObjects = arrayController.selectedObjects else { return }
        guard let url = (selectedObjects[0] as? Article)?.url else { return }
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func nextFeedSelected(_ sender: Any) {
        let splitView = view.superview?.superview as? NSSplitView
        view.window?.makeFirstResponder(splitView?.arrangedSubviews.first?.subviews.first)
    }

    @IBAction func previousFeedSelected(_ sender: Any) {
        nextFeedSelected(sender)
    }
    
    @IBAction func nextArticleSelected(_ sender: Any) {
        arrayController.selectNext(self)
        DispatchQueue.main.async {
            self.articleTableView.scrollSelectedToVisibleWithAnimation()
        }
    }
    
    @IBAction func previousArticleSelected(_ sender: Any) {
        arrayController.selectPrevious(self)
        DispatchQueue.main.async {
            self.articleTableView.scrollSelectedToVisibleWithAnimation()
        }
    }
    
    @IBAction func nextPageSelected(_ sender: Any) {
        articleTableView.scrollPageDown(self)
    }

    @IBAction func previousPageSelected(_ sender: Any) {
    }
}

extension FeedContentsController: SelectedFeedObserver {
    func onSelectedFeedChanged() {
        guard let feed = SelectedFeed.shared.feed else { return }
        feed.markArticlesAsShown()
        (NSApplication.shared.delegate! as! AppDelegate).updateUnreadCountBadge()

        arrayController.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        arrayController.fetchPredicate = NSPredicate(format: "feed == %@", feed)
        arrayController.fetch(nil)
        arrayController.setSelectionIndex(0)
        DispatchQueue.main.async {
            self.articleTableView.scrollSelectedToVisibleWithAnimation()
        }
    }
}
