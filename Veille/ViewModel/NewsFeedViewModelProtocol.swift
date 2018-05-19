//
//  NewsFeedViewModel.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit

protocol NewsFeedViewModelProtocol {
    var articles:[Article] { get }
    var dataFetched:(() -> ())? { get set }
    var dataSource:[UITableViewCell]  { get }
    func refresh()
    func addArticle()
}
