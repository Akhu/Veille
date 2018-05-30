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

    enum CodingKeys: String, CodingKey {
        case title
        case summary = "description"
        case link
        case image = "imageURL"
        case createdDate = "date"
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encode(self.link, forKey: .link)
        try container.encode(self.createdDate.toIso8601(), forKey: .createdDate)
    }
    
}

extension Article: CoreDataDecodable{
    static func findOrCreate(for dto: Article.DTO, in context: NSManagedObjectContext) throws -> Self {
        return existingArticle(type: self)
        //
        if var article = CoreDataStack.store.fetchArticleBy(id: dto.id) {
            do {
                try article.update(from: dto)
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    private class func existingArticle<T>(type: T.Type) -> T {
        //
    }
    
    func update(from dto: Article.DTO) throws {
        id = dto.id
        title = dto.title
        summary = dto.summary
        
        guard let url = URL(string: dto.link) else {
            let context = DecodingError.Context(codingPath: [CodingKeys.link], debugDescription: "Link string is not convertible to URL")
            throw DecodingError.typeMismatch(URL.self, context)
        }
        
        link = url
    }
    
    struct DTO: Decodable {
        
        let id: Int32
        let title: String
        let summary: String?
        let link: String!
        //let image: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case summary = "description"
            case link
            //case image = "imageURL"
            //case createdDate = "date"
        }
        
        
    }
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
