//
//  NewsFeedTableViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class NewsFeedTableViewController: UITableViewController {
    
    let ref = Database.database().reference(withPath: "veille")
    let articlesRef = Database.database().reference(withPath: "veille/articles")
    
    var articles: [Article] = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesRef.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
            
            self.articles.removeAll()
            do {
                for encodedArticle in snapshot.children {
                    if let articleSnapshot = encodedArticle as? DataSnapshot {
                        self.articles.append(try FirebaseDecoder().decode(Article.self, from: articleSnapshot.value))
                    }
                }
                self.tableView.reloadData()
            } catch let exception {
                print(exception)
            }
            
        })
    }
    
    //FetchResult controller will manage this instance with the control of TableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.articles[indexPath.row].link.absoluteString
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = self.articles[indexPath.row]
            article.ref.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles[indexPath.row]
        UIApplication.shared.open(article.link, options: [:], completionHandler: nil)
    }
}

extension NewsFeedTableViewController {
    func configure(_ cell: ArticleTableViewCell, for object: Article) {
        cell.configure(for: object)
    }
}
