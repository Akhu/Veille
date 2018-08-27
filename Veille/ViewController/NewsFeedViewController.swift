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

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    //FetchResult controller will manage this instance with the control of TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  self.tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.articles[indexPath.row].link.absoluteString
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = self.articles[indexPath.row]
            article.ref.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles[indexPath.row]
        UIApplication.shared.open(article.link, options: [:], completionHandler: nil)
    }
}

class NewsFeedViewController: UIViewController {
    
    var progressWhenInterrupted:CGFloat = 0
    
    let duration:TimeInterval = 0.575
    
    @IBOutlet weak var holdView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var parentReceiptViewController: RootViewController? {
        get {
            return self.parent as? RootViewController
        }
    }
    
    var articles: [Article] = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.holdView.addGestureRecognizer(tapGesture)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureHandler))
        self.view.addGestureRecognizer(gesture)
        
        self.holdView.layer.cornerRadius = self.holdView.bounds.height / 2
        
        articleRef.observe(.value, with: { snapshot in
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
}

extension NewsFeedViewController {
    @objc func tapHandler(_ recognizer: UITapGestureRecognizer){
        guard let parentVC = self.parentReceiptViewController else { return }
        
        self.parentReceiptViewController?.animateOrReverseRunningTransition(state: !parentVC.currentState, duration: duration)
    }
    
    @objc func gestureHandler(_ recognizer: UIPanGestureRecognizer){
        guard let parentVC = self.parentReceiptViewController else { return }
        switch recognizer.state {
        case .began:
            parentVC.startInteractiveTransaction(state: !parentVC.currentState, duration: duration)
            //print("State : \(parentVC.currentState)")
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            parentVC.updateInteractiveTransition(distanceTraveled: translation.y)
        case .cancelled, .failed:
            self.parentReceiptViewController?.continueInteractiveTransition(cancel: true)
        case .ended:
            let isCancelled = isGestureCancelled(recognizer)
            self.parentReceiptViewController?.continueInteractiveTransition(cancel: isCancelled)
        default:
            break
        }
    }
    
    
    private func isGestureCancelled(_ recognizer: UIPanGestureRecognizer) -> Bool {
        let isCancelled: Bool
        guard let parentVC = self.parentReceiptViewController else { return false }
        
        let velocityY = recognizer.velocity(in: view).y
        if velocityY != 0 {
            let isPanningDown = velocityY > 0
            isCancelled = (parentVC.currentState == .expanded && isPanningDown) ||
                (parentVC.currentState == .collapsed && !isPanningDown)
        }
        else {
            isCancelled = false
        }
        
        return isCancelled
    }
    
    
    func roundView() {
        self.view.layer.cornerRadius = 6
        self.holdView.layer.cornerRadius = self.holdView.bounds.height / 2
        self.view.clipsToBounds = true
    }
}
