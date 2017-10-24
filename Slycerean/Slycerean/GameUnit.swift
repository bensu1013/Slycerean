//
//  UnitEntity.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum Direction: String {
    case up, down, left, right
}

class GameUnit {

    var firstName: String = "First"
    var lastName: String = "Last"
    
    var maximumHealthPoints: Int = 32
    var totalMovementSteps: Int = 4
    var totalMagicPowers = 2
    
    var equippedSkills = [BSActivatableSkill]()
    
    init() {
        equippedSkills.append(BSFireballSkill())
    }
    
}




