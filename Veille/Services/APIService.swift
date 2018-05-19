//
//  APIService.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

class APIService {

    typealias JSON = [String:Any]

    let baseUrl: URL = URL(string: "http://localhost:3030")!

    init() {

    }

    func returnArticlesFromMock() -> [Article] {
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                print(String(bytes: data, encoding: .utf8))
                let context = CoreDataStack.store.persistentContainer.newBackgroundContext()
                let plistDecoderForArticle = PropertyListDecoder()
                plistDecoderForArticle.userInfo[CodingUserInfoKey.context!] = context
                let decodedData = try plistDecoderForArticle.decode([Article].self, from: data)
                return decodedData
            } catch let error as NSError {
                print(error.description)
                return [Article]()
            }
        }

        return [Article]()
    }

    func fetchArticles(_ completion: @escaping (([Article]) -> Void)) {
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                print(String(bytes: data, encoding: .utf8))
                let context = CoreDataStack.store.persistentContainer.newBackgroundContext()
                let plistDecoderForArticle = PropertyListDecoder()
                plistDecoderForArticle.userInfo[CodingUserInfoKey.context!] = context
                let decodedData = try plistDecoderForArticle.decode([Article].self, from: data)
//                for article in decodedData {
//                    CoreDataStack.store.persistArticle(article: article)
//                }
                CoreDataStack.store.saveContext()
                completion(decodedData)
            } catch let error as NSError {
                print(error.description)
                completion([Article]())
            }

        }else {
            completion([Article]())
        }

//        let url = baseUrl.appendingPathComponent("article")
//
//        Alamofire.request(url).responseData { (response) in
//            if let data = response.data {
//                print(String(data: data, encoding: .utf8))
//                completion(data)
//            }
//        }
    }
}
