//
//  SelectedFeed.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/02.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

protocol SelectedFeedObserver: class {
    func onSelectedFeedChanged()
}

class SelectedFeed {
    static let shared = SelectedFeed()
    weak var observer: SelectedFeedObserver?
    var feed: Feed? {
        didSet {
            observer?.onSelectedFeedChanged()
        }
    }
}
