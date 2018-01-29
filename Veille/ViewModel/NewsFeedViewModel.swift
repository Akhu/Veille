//
//  NewsFeedViewModel.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

class NewsFeedViewModel: NSObject, NewsFeedViewModelProtocol {
    var articles: Articles?
    
    func fetchData(){
        APIService().fetchArticles { (dataReceived) in
            do {
                let articlesJson = try JSONSerialization.jsonObject(with: dataReceived, options: JSONSerialization.ReadingOptions.allowFragments)
                print(articlesJson)
                //self.articles = try JSONDecoder().decode(Articles.self, from: articlesJson)
            } catch {
                print("cannot decode data")
                //print(articles)
            }
        }
    }
    
    override init() {
        super.init()
        self.fetchData()
    }
}
