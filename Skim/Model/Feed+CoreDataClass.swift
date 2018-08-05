//
//  Feed+CoreDataClass.swift
//  Skim
//
//  Created by Tetsui Ohkubo on 2018/08/02.
//  Copyright © 2018年 peryaudo. All rights reserved.
//
//

import Foundation
import CoreData
import FeedKit

@objc(Feed)
public class Feed: NSManagedObject {
    @objc let isLeaf: Bool = true

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
    
    class func getTotalUnreadCount(context: NSManagedObjectContext) -> Int64 {
        let request: NSFetchRequest<Feed> = Feed.fetchRequest()
        var feeds: [Feed] = []
        context.performAndWait {
            feeds = (try? request.execute()) ?? []
        }
        return
            feeds.map { (feed) -> Int64 in
                return feed.unreadCount
            }.reduce(0, +)
    }
    
    func updateUnreadCount() {
        let previousUnreadCount = unreadCount
        unreadCount =
            articles?.map({ (article) -> Int64 in
                (article as! Article).shown ? 0 : 1
            }).reduce(0, +) ?? 0
        folder?.unreadCount += unreadCount - previousUnreadCount
    }
    
    func markArticlesAsShown() {
        guard let articles = articles else { return }
        for article in articles {
            (article as! Article).shown = true
        }
        updateUnreadCount()
        do {
            try managedObjectContext!.save()
        } catch {
            print("cannot save")
        }
    }

    func retrieveFromUrl(closure: @escaping () -> Void) {
        guard let url = url else { return }
        guard let context = managedObjectContext else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let result = FeedParser(data: data).parse()
            DispatchQueue.main.async {
                self.managedObjectContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                self.addToArticles(result: result)
                self.updateUnreadCount()
                do {
                    try context.save()
                } catch {
                    print("cannot save")
                }
                closure()
            }
        }
        task.resume()
    }
    
    func addToArticles(result: Result) {
        switch result {
        case let .rss(feed):
            self.title = feed.title
            guard let items = feed.items else { return }
            for item in items {
                addToArticles(Article.parse(item: item, context: managedObjectContext!))
            }
        case .atom(_):
            return
        case .json(_):
            return
        case .failure(_):
            return
        }
    }
}
