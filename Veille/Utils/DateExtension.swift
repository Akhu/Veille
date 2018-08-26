//
//  DateExtension.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

extension Date {
    func toDisplayFormat() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
