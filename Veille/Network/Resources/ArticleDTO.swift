//
//  ArticleDTO.swift
//  Veille
//
//  Created by Anthony Da Cruz on 19/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
//Will use this object to populate / CRUD coreData
class ArticleDTO: Codable {
    
    var title:String!
    var summary:String?
    var link:String!
    var image:URL?
    var createdDate: String!
    var id: Int32 = 0
    
    enum CodingKeys: String, CodingKey {
        case title
        case summary = "description"
        case link = "url"
        case image = "imageURL"
        case createdDate = "createdOn"
        case id
    }
}

extension ArticleDTO {
    
}


