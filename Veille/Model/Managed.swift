//
//  Managed.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData


protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [] //No sort descriptor by default
    }
    
    //Default implementation of the sorted fetchrequest
    static var sortedFetchRequest:NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

// Allow us to have a valid entity name by default, based on our NSManagedObject
extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
}


