//
//  CoreDataDecodable.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataDecodable: Decodable {
    associatedtype DataTransferObject: Decodable
    
    @discardableResult
    static func findOrCreate(for dto: DataTransferObject, in context: NSManagedObjectContext) throws -> Self
    
    init(with dto: DataTransferObject, in context: NSManagedObjectContext) throws
    
    mutating func update(from dto: DataTransferObject) throws
}
