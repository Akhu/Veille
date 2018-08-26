//
//  Article.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

class Article: Codable {

    var title:String!
    var summary:String?
    var link:URL!
    var image:URL?
    var createdDate: Date
    var id: Int32
    //var tags:[String]?
    
}


// MARK: Querying
