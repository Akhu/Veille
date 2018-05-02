//
//  NewsFeedViewModel.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedViewModel: NSObject, NewsFeedViewModelProtocol {
    var dataSource: [UITableViewCell] = [UITableViewCell]() {
        didSet {
            self.dataFetched?()
        }
    }
    //should implement NewsFeedProtocol and ViewModelTableViewProtocol
    var dataFetched: (() -> ())?
    
    lazy var articles: [Article] = [Article]()
    
    //@Todo => if network is unavailable -> CoreData
    /**
     Fetching data from server and return this newsFeedViewModel as instance with all our articles loaded and ready
     */
    func fetchData(_ completion: @escaping ((Articles?) -> Void)){
        APIService().fetchArticles { (dataReceived) in
            do {
                let articlesReceived = try JSONDecoder().decode(Articles.self, from: dataReceived)
                completion(articlesReceived)
            } catch let error as NSError {
                print(error)
                completion(nil)
            }
        }
    }
    
    func processFetchedArticles(articles: Articles) {
        self.articles = articles.articles
        var articlesCells:[UITableViewCell] = [UITableViewCell]()
        
        articlesCells = self.articles.map({ (currentArticle: Article) -> UITableViewCell in
            let articleCell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "articleCell")
            articleCell.textLabel?.text = currentArticle.title
            articleCell.detailTextLabel?.text = currentArticle.link.absoluteString
            return articleCell
        })
        
        self.dataSource = articlesCells
    }
    
    
    
    override init() {
        super.init()
    
        self.fetchData { [weak self] articles in
            if let receivedArticles = articles {
                self?.processFetchedArticles(articles: receivedArticles)
            }else {
                print("Error while fetching articles") //Replace with try?
            }
        }
    }
}
