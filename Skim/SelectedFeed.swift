//
//  SelectedFeed.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/02.
//  Copyright © 2018年 peryaudo. All rights reserved.
//

import Cocoa

class SelectedFeed: NSObject {
    static let shared = SelectedFeed()
    @objc dynamic var feed: Feed?
}
