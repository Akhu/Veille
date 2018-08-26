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

class RootViewController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case childViewController = "newsFeed"
    }
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .childViewController:
            guard let childVc = segue.destination as? NewsFeedTableViewController else { fatalError("Wrong view controller type") }
            
            break
        }
    }
    
    
    //Child view controller management goes here
}
