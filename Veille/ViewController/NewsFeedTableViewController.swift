//
//  NewsFeedTableViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewsFeedTableViewController: UITableViewController, CoreDataAware {
    var managedObjectContext: NSManagedObjectContext!
    
    var dataSource:TableViewDataSource<NewsFeedTableViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //FetchResult controller will manage this instance with the control of TableViewDataSource
    
    
}

extension NewsFeedTableViewController: TableViewDataSourceDelegate {
    func configure(_ cell: ArticleTableViewCell, for object: Article) {
        cell.configure(for: object)
    }
}
