//
//  FeedContentsTableView.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/05.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class FeedContentsTableView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func scrollSelectedToVisibleWithAnimation() {
        let rowRect = rect(ofRow: selectedRow)
        guard let viewRect = superview?.frame else {
            return
        }
        var scrollOrigin = rowRect.origin
        scrollOrigin.y = scrollOrigin.y + (rowRect.size.height - viewRect.size.height) / 2
        if scrollOrigin.y < 0 {
            scrollOrigin.y = 0
        }
        superview?.animator().setBoundsOrigin(scrollOrigin)
    }
}
