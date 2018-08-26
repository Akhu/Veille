//
//  RootViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RootViewController: UIViewController, CoreDataAware, SegueHandler {
    
    enum SegueIdentifier: String {
        case childViewController = "newsFeed"
    }
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostsApi.posts.addObserver(owner: self) { [weak self] (posts, event) in
            print(posts)
        }
        
        PostsApi.posts.loadIfNeeded()?.onFailure({ (error) in
            print(error.cause)
        })
        
       
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .childViewController:
            guard let childVc = segue.destination as? NewsFeedTableViewController else { fatalError("Wrong view controller type") }
            childVc.managedObjectContext = self.managedObjectContext
            break
        }
    }
    
    
    //Child view controller management goes here
}
