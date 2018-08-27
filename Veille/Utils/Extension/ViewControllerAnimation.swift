//
//  ViewControllerAnimation.swift
//  Veille
//
//  Created by Anthony Da Cruz on 27/08/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit

enum BottomSheetAnimationState {
    case collapsed
    case expanded
}

prefix func !(_ state: BottomSheetAnimationState) -> BottomSheetAnimationState {
    return state == BottomSheetAnimationState.expanded ? .collapsed : .expanded
}

