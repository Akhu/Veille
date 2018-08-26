//
//  NewsFeedViewModel.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NewsFeedViewModel: NSObject, NewsFeedViewModelProtocol{
    
    
    override init() {
        super.init()
        
        self.observers()
        
        self.refresh()
    }

    
    func observers() {
       
    }
    
    func refresh() {
       
    }


    func addArticle() {
//        let articleMockList = APIService().returnArticlesFromMock()
//
//        for articleMock in articleMockList {
//            CoreDataStack.store.persistArticle(article: articleMock)
//        }
//
//        CoreDataStack.store.saveContext()
        
       // manage
    }

//    func processFetchedArticles(articles: [Article]) {
//        self.articles = articles
//        var articlesCells:[UITableViewCell] = [UITableViewCell]()
//
//        articlesCells = self.articles.map({ (currentArticle: Article) -> UITableViewCell in
//            let articleCell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "articleCell")
//            articleCell.textLabel?.text = currentArticle.title
//            articleCell.detailTextLabel?.text = currentArticle.link.absoluteString
//            return articleCell
//        })
//
//        self.dataSource = articlesCells
//    }



}
