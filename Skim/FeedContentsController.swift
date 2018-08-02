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
        arrayController.content = feed.articles
    }
}
