//
//  APIService.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    typealias JSON = [String:Any]
    
    let baseUrl: URL = URL(string: "http://localhost:3030")!
    
    init() {
        
    }
    
    func fetchArticles(_ completion: @escaping ((Data) -> Void)) {
        let url = baseUrl.appendingPathComponent("article")
        
        Alamofire.request(url).responseData { (response) in
            if let data = response.data {
                print(String(data: data, encoding: .utf8))
                completion(data)
            }
        }
    }
}
