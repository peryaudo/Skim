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
    @objc let isLeaf: Bool = false
    
    @objc var titleWithCount: String {
        if unreadCount > 0 {
            return "\(title ?? "") (\(unreadCount))"
        } else {
            return title ?? ""
        }
    }
    
    @objc class func keyPathsForValuesAffectingTitleWithCount() -> NSSet {
        return ["title", "unreadCount"]
    }
}
