//
//  Article+CoreDataClass.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/04.
//  Copyright © 2018年 peryaudo. All rights reserved.
//
//

import Foundation
import CoreData
import FeedKit

@objc(Article)
public class Article: NSManagedObject {
    class func parse(item: RSSFeedItem, context: NSManagedObjectContext) -> Article {
        let article = Article(context: context)
        article.date = item.pubDate ?? item.dublinCore?.dcDate
        article.title = item.title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        article.contents = item.description
        if let link = item.link {
            article.url = URL(string: link)
        }
        return article
    }
}
