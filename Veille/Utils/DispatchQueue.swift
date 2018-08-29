//
//  DispatchQueue.swift
//  Veille
//
//  Created by Anthony Da Cruz on 29/08/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation

let imageQueue = DispatchQueue(label: "imageLoading", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
