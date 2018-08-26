//
//  RootViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class RootViewController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case childViewController = "newsFeed"
    }
    
    let ref = Database.database().reference(withPath: "veille")
    let articlesRef = Database.database().reference(withPath: "veille/articles")
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add Article URL", message: "", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "URL of article..."
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first,
                let text = textField.text else { return }
            
            guard let article = Article(url: text) else { return }
            
            let articleRef = self.articlesRef.child(article.id)
            let encodedData = try? FirebaseEncoder().encode(article)
            articleRef.setValue(encodedData)
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
        
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
