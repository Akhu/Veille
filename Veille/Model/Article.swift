//
//  Article.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Article: Codable {

    var title:String?
    var summary:String?
    var link:URL!
    var image:URL?
    //@todo : ISO8601 for codable / decodable
    var createdDate: Date
    //@todo : refactor UUID() into codable / decodable
    var id: String
    
    init?(url: String){
        //@todo : refactor UUID() into codable / decodable
        self.id = UUID().uuidString
        guard let urlLink = URL(string: url) else { return nil }
        self.createdDate = Date()
        self.link = urlLink
    }
    
    init?(url: String, title: String){
        self.id = UUID().uuidString
        self.title = title
        self.createdDate = Date()
        guard let urlLink = URL(string: url) else { return nil }
        self.link = urlLink
    }
    
}

// MARK: Querying
extension Article {
    var ref:DatabaseReference {
        return Database.database().reference(withPath: "veille/articles/\(self.id)")
    }
    
    func save() throws {
        let encodedData = try? FirebaseEncoder().encode(self)
        articleRef.child(self.id).setValue(encodedData)
    }
    
    func remove() {
        self.ref.removeValue()
    }
}
