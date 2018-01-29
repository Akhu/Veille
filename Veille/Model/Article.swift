//
//  Article.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import Alamofire

struct Articles: Codable {
    let articles: [Article]
}
class Article: Codable {
    
    var title:String
    var summary:String?
    var link:URL
    var imageURL:URL?
    var tags:Tags?
    var id:UUID
    
    init(withTitle title:String, andLink link: URL) {
        self.id = UUID()
        self.link = link
        self.title = title
    }
    
    init() {
        self.id = UUID()
        self.link = URL(string: "http://localhost:3030")!
        self.title = "Title"
    }
}
