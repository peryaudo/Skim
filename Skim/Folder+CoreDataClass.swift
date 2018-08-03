//
//  Folder+CoreDataClass.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/03.
//  Copyright © 2018年 peryaudo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    @objc var titleWithCount: String {
        let count = self.feeds?.map({ (feed) -> Int in
            return (feed as! Feed).articles?.count ?? 0
        }).reduce(0, +)
        return "\(title ?? "") (\(count ?? 0))"
    }
}
