//
//  Article.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject, Decodable {

    @NSManaged var title:String!
    @NSManaged var summary:String?
    @NSManaged var link:URL!
    @NSManaged var image:URL?
    @NSManaged var createdDate: Date
    //var tags:[String]?

    enum CodingKeys: String, CodingKey {
        case title
        case summary = "description"
        case link
        case image = "imageURL"
        case createdDate = "date"
    }

    required convenience init(from decoder: Decoder) throws {

        guard let contextUserInfoKey = CodingUserInfoKey.context else { fatalError("cannot find context key") }

        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError("cannot Retrieve context") }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Article", in: managedObjectContext) else { fatalError() }

        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.createdDate = Date()
        self.title = try values.decode(String.self, forKey: .title)

        self.summary = try values.decode(String.self, forKey: .summary)

        guard let linkString = try values.decodeIfPresent(String.self, forKey: .link) else { return }
        if let linkUrl = URL(string: linkString) {
            self.link = linkUrl
        }

        if let imageURLString = try values.decodeIfPresent(String.self, forKey: .image) {
            if let imageURL = URL(string: imageURLString){
                self.image = imageURL
            }
        }
        print(self.image)
    }
}

extension Article: Encodable{

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encode(self.link, forKey: .link)
        try container.encode(self.createdDate.toIso8601(), forKey: .createdDate)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
