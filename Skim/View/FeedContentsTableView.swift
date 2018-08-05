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
        superview?.animator().setBoundsOrigin(rect(ofRow: selectedRow).origin)
    }
}
