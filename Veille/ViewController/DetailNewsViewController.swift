//
//  DetailNewsViewController.swift
//  Veille
//
//  Created by Anthony Da Cruz on 04/02/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit

class DetailNewsViewController: UIViewController {
    
    private let viewModel:DetailNewsViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(withViewModel vm: DetailNewsViewModel){
        self.viewModel = vm
        super.init(nibName: nil, bundle: Bundle.main)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    
}
