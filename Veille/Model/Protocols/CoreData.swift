//
//  File.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataAware {
    var managedObjectContext: NSManagedObjectContext! { get set }
}
