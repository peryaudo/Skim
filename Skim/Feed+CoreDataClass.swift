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

    func retrieveFromUrl() {
        guard let url = url else { return }
        guard let context = managedObjectContext else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let result = FeedParser(data: data).parse()
            DispatchQueue.main.async {
                self.addToArticles(result: result)
                do {
                    try context.save()
                } catch {
                    print("cannot save")
                }
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
                let article = Article()
                article.date = item.pubDate
                article.title = item.title
                if let url = item.source?.value {
                    article.url = URL(string: url)
                }
                addToArticles(article)
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
