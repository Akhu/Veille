//
//  Tag.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/01/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

struct Tags: Codable {
    let tags: [Tag]
}

class Tag: Codable {
    let name:String
}
