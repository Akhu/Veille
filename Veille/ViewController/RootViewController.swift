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


extension RootViewController {

    static let bottomSheetViewExpandedTopMargin: CGFloat = 164
    static var bottomSheetViewCollapsedHeight: CGFloat {
        return 100
    }

    func animateTransitionIfNeeded(state: BottomSheetAnimationState, duration: TimeInterval){
        //print("Current state : \(self.currentState)")
        if runningAnimators.isEmpty {
            
            self.currentState = state //updating our variable
            let cornerAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
                switch state {
                case .collapsed:
                    self.newFeedTableViewSheetController.view.layer.cornerRadius = 20
                case .expanded:
                    self.newFeedTableViewSheetController.view.layer.cornerRadius = 12
                }
            })
            
            cornerAnimator.addCompletion({ (_) in
                self.runningAnimators = self.runningAnimators.filter { $0 != cornerAnimator }
            })
            
            
            let subViewControllerAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
                switch self.currentState {
                case .collapsed:
                    let receiptViewFrame = self.view.frame
                    self.newFeedTableViewSheetController.view.frame = CGRect(x: receiptViewFrame.minX, y: self.view.frame.height - RootViewController.bottomSheetViewCollapsedHeight, width: receiptViewFrame.width, height: receiptViewFrame.height)
                    break
                case .expanded:
                    self.newFeedTableViewSheetController.view.frame = CGRect(x: self.view.frame.minX, y: RootViewController.bottomSheetViewExpandedTopMargin, width: self.view.frame.width, height: self.view.frame.height)
                    break
                }
            })
            subViewControllerAnimator.addCompletion({ (_) in
                self.runningAnimators = self.runningAnimators.filter { $0 != subViewControllerAnimator }
            })
            
            cornerAnimator.startAnimation()
            self.runningAnimators.append(cornerAnimator)
            subViewControllerAnimator.startAnimation()
            self.runningAnimators.append(subViewControllerAnimator)
        }
    }
    
    
    func animateOrReverseRunningTransition(state: BottomSheetAnimationState, duration: TimeInterval){
        if runningAnimators.isEmpty {
            self.animateTransitionIfNeeded(state: state, duration: duration)
        }else {
            for animator in self.runningAnimators {
                animator.isReversed = !animator.isReversed
            }
            
            self.currentState = !self.currentState
        }
    }
    
    func startInteractiveTransaction(state: BottomSheetAnimationState, duration: TimeInterval){
        animateTransitionIfNeeded(state: state, duration: duration)
        
        progressWhenInterrupted = [:]
        for animator in runningAnimators {
            animator.pauseAnimation()
            progressWhenInterrupted[animator] = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(distanceTraveled: CGFloat){
        let totalAnimationDistance =  self.view.frame.height - RootViewController.bottomSheetViewCollapsedHeight
        let fractionComplete = distanceTraveled / totalAnimationDistance
        //print("distance: \(distanceTraveled) / fraction: \(fractionComplete) / totalAnimationDistance : \(totalAnimationDistance)")
        for animator in runningAnimators {
            if let progressWhenInterrupted = progressWhenInterrupted[animator] {
                let relativeFractionComplete = fractionComplete + progressWhenInterrupted
                
                if (self.currentState == .expanded && relativeFractionComplete > 0) || (self.currentState == .collapsed && relativeFractionComplete < 0) {
                    animator.fractionComplete = 0
                }else if (currentState == .expanded && relativeFractionComplete < -1) || (currentState == .collapsed && relativeFractionComplete > 1) {
                    animator.fractionComplete = 1
                }else {
                    animator.fractionComplete = abs(fractionComplete) + progressWhenInterrupted
                }
            }
        }
    }
    
    func continueInteractiveTransition(cancel: Bool){
        print("runnings animators : \(self.runningAnimators.count)")
        if cancel {
            for animator in runningAnimators {
                print("animator status : \(animator.isReversed)")
                animator.isReversed = !animator.isReversed
                print("animator status 2 : \(animator.isReversed)")
            }
        }
        
        let timing = UICubicTimingParameters(animationCurve: .easeOut)
        for animator in runningAnimators {
            animator.continueAnimation(withTimingParameters: timing, durationFactor: 0)
        }
    }
}

class RootViewController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case childViewController = "newsFeed"
    }
    
    // - MARK: Animations
    
    var animator: UIViewPropertyAnimator!
    
    // Tracks progress when interrupted for all Animators
    var progressWhenInterrupted = [UIViewPropertyAnimator : CGFloat]()
    
    var currentState: BottomSheetAnimationState = .collapsed
    
    var panGestureCalled:(() -> ())?
    
    var runningAnimators = [UIViewPropertyAnimator]()
  
    var newFeedTableViewSheetController:NewsFeedViewController!
    
    // - MARK: Model
    
    lazy var newsFeedVM:NewsFeedViewModelProtocol = {
        return NewsFeedViewModel()
    }()
    
    // - MARK: Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newsFeedViewControllerInstance = storyBoard.instantiateViewController(withIdentifier: "newsFeed") as? NewsFeedViewController else { fatalError("Cannot instantiate newsFeed" )}
        
        self.newFeedTableViewSheetController = newsFeedViewControllerInstance
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addBottomSheetView()
    
        self.newFeedTableViewSheetController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.newFeedTableViewSheetController.view.layer.cornerRadius = 20
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.newFeedTableViewSheetController.view.frame = CGRect(x: self.view.frame.minX, y: RootViewController.bottomSheetViewExpandedTopMargin, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func addBottomSheetView() {
        self.addChildViewController(newFeedTableViewSheetController)
        self.view.addSubview(newFeedTableViewSheetController.view)
        
        let height = view.frame.height
        let width = view.frame.width
        
        //Put the sheet view at the very bottom
        newFeedTableViewSheetController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
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
        
            let encodedData = try? FirebaseEncoder().encode(article)
            articleRef.child(article.id).setValue(encodedData)
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
