//
//  FirebaseHandler.swift
//  Veille
//
//  Created by Anthony Da Cruz on 26/08/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import Firebase

let rootRef: DatabaseReference = Database.database().reference(withPath: "veille")
let articleRef: DatabaseReference = Database.database().reference(withPath: "veille/articles")
