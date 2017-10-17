//
//  BSAttackPattern.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/16/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

struct BSAttackPattern {
    var pattern: BSAttackPatternStyle
    var distance: Int
}

enum BSAttackPatternStyle {
    // Used to build an attack pattern
    case cross(Int),square(Int),diamond(Int),point
}




