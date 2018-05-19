//
//  FirstViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //let article = Article(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
        self.initView()
        
        self.bindingViewModel()
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
        self.newsFeedVM.dataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsFeedVM.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.newsFeedVM.dataSource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

