//
//  CoreDataStack.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

import CoreData


extension CoreDataStack {
    static var mainContainer = "Veille"
}


class CoreDataStack {
    
    static func createVeilleContainer(completion: @escaping (NSPersistentContainer) -> ()){
        let container = NSPersistentContainer(name: CoreDataStack.mainContainer)
        
        container.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError("Failed to load store: \(error!)") }
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
}


// - MARK: NSFetched Request related
