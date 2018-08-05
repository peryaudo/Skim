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
        //article.contents = convertHtml(html: item.description)
        if let link = item.link {
            article.url = URL(string: link)
            let request: NSFetchRequest<Article> = Article.fetchRequest()
            request.predicate = NSPredicate(format: "url == %@", link)
            context.performAndWait {
                if let existing = ((try? request.execute())?.first) {
                    article.shown = existing.shown
                }
            }
        }
        return article
    }
    
    private class func convertHtml(html: String?) -> String? {
        guard let html = html else {
            return nil
        }
        guard let data = html.data(using: .utf16) else { return nil }
        // TODO(tetsui): Fix NSURLConnection finished with error - code -1002
        let attributedString =
            NSAttributedString(html: data,
                               options: [.documentType: NSAttributedString.DocumentType.html],
                               documentAttributes: nil)
        return attributedString?.string
    }
}
