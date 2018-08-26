//
//  Extension+Date.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

extension Date {
    func toIso8601() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
}
