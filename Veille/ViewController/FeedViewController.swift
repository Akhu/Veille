//
//  FirstViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class FeedViewController: UIViewController, FirebaseRealtimeDBAware {

    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference(withPath: "veille")
    let articlesRef = Database.database().reference(withPath: "veille/articles")
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindingViewModel()
        
        ref.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    func initView(){
        //Initializing view with placeholder / loader
    }
    @IBAction func rightViewButtonAction(_ sender: UIButton) {
        self.newsFeedVM.refresh()
        self.newsFeedVM.addArticle()
    }
    
    func bindingViewModel(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        
    }
}

