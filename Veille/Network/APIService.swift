//
//  APIService.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import Siesta

let baseUrl = "http://link.d3c.re/api"

let PostsApi = _PostsServiceAPI()

class _PostsServiceAPI: Service {
    
    fileprivate init() {
        super.init(baseURL: baseUrl)
        
        #if DEBUG
            Siesta.LogCategory.enabled = LogCategory.common
        #endif
        
        configure {
            $0.headers["accept"] = "application/json"
            $0.pipeline.order = [.rawData, .decoding, .model, .cleanup]
        }
        
        let jsonDecoder = JSONDecoder()
        
        self.configureTransformer("/posts") {
            try jsonDecoder.decode([ArticleDTO].self, from: $0.content)
        }
        
    }
    
    var posts: Resource { return resource("/posts") }
    
    func post(id: String) -> Resource {
        return posts.child(id)
    }

    func returnArticlesFromMock() -> [ArticleDTO] {
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                print(String(bytes: data, encoding: .utf8))
                //let context = CoreDataStack.store.persistentContainer.newBackgroundContext()
                let plistDecoderForArticle = PropertyListDecoder()
                let decodedData = try plistDecoderForArticle.decode([ArticleDTO].self, from: data)
                return decodedData
            } catch let error as NSError {
                print(error.description)
                return [ArticleDTO]()
            }
        }

        return [ArticleDTO]()
    }
}
