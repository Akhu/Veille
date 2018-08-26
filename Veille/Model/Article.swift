//
//  Article.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject, Encodable {

    @NSManaged var title:String!
    @NSManaged var summary:String?
    @NSManaged var link:URL!
    @NSManaged var image:URL?
    @NSManaged var createdDate: Date
    @NSManaged var id: Int32
    //var tags:[String]?
    
}


// MARK: Querying

extension Article: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(createdDate), ascending: false)]
    }
}
