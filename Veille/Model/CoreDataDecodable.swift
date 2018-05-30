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
    associatedtype DTO: Decodable
    
    @discardableResult
    static func findOrCreate(for dto: DTO, in context: NSManagedObjectContext) throws -> Self
    
    init(with dto: DTO, in context: NSManagedObjectContext) throws
    
    mutating func update(from dto: DTO) throws
}

enum CoreDataDecodingError: Error {
    case missingContext(codingPath: [CodingKey])
}

extension NSManagedObjectContext {
    private static var _decodingContext: NSManagedObjectContext?
    
    static func decodingContext(at codingPath: [CodingKey] = []) throws -> NSManagedObjectContext {
        if let context = _decodingContext { return context }
        throw CoreDataDecodingError.missingContext(codingPath: codingPath)
    }
    
    public final func asDecodingContext(do work: () -> ()) {
        NSManagedObjectContext._decodingContext = self
        defer {
            NSManagedObjectContext._decodingContext = nil
        }
        performAndWait {
            work()
        }
    }
}

extension CoreDataDecodable {
    init(from decoder: Decoder) throws {
        try self.init(with: DTO(from: decoder), in: .decodingContext(at: decoder.codingPath))
    }
}

extension CoreDataDecodable where Self: NSManagedObject {
    init(with dto: DTO, in context: NSManagedObjectContext)  throws {
        self.init(context: context)
        try update(from: dto)
    }
}

//required convenience init(from decoder: Decoder) throws {
//
//    guard let contextUserInfoKey = CodingUserInfoKey.context else { fatalError("cannot find context key") }
//
//    guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError("cannot Retrieve context") }
//
//    guard let entity = NSEntityDescription.entity(forEntityName: "Article", in: managedObjectContext) else { fatalError() }
//
//    self.init(entity: entity, insertInto: nil)
//
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    self.createdDate = Date()
//    self.title = try values.decode(String.self, forKey: .title)
//
//    self.summary = try values.decode(String.self, forKey: .summary)
//
//    guard let linkString = try values.decodeIfPresent(String.self, forKey: .link) else { return }
//    if let linkUrl = URL(string: linkString) {
//        self.link = linkUrl
//    }
//
//    if let imageURLString = try values.decodeIfPresent(String.self, forKey: .image) {
//        if let imageURL = URL(string: imageURLString){
//            self.image = imageURL
//        }
//    }
//    print(self.image)
//}
