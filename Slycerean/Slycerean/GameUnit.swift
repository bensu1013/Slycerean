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

enum BSGameUnitJob {
    case warrior, wizard, ranger, rogue
}

struct BSCharacterStats {
    var health: Int
    var energy: Int
    
    var actionSpeed: Int
    var level: Int
    var job: BSGameUnitJob
    var jobLevels: [BSGameUnitJob:Int]
}

struct BSCharacterEquipment {
    var weapon: String      // effects basic skill used, and damage dealt
    var armor: String       // effects damage reduction
    var relic: String       // special bonuses
}

class GameUnit {

    var baseStats: BSCharacterStats
    var equipment: BSCharacterEquipment
    
    var firstName: String = "First"
    var lastName: String = "Last"
    
    var maximumHealth: Int {
        return baseStats.health
    }
    var maximumEnergy: Int {
        return baseStats.energy
    }
    var maximumMovement: Int {
        return 4
    }
    var actionSpeed: Int {
        return baseStats.actionSpeed
    }
    var attackPower: Int = 1
    var spellPower: Int = 1
    
    var basicAttack: BSActivatableSkill
    var equippedSkills = [BSActivatableSkill]()
    
    init(stats: BSCharacterStats, equipment: BSCharacterEquipment) {
        self.baseStats = stats
        self.equipment = equipment
        
        basicAttack = WarriorBasicSkill()
        equippedSkills.append(BSFireballSkill())
    }
    
}

class BSGameUnitSkillComponent {
    
    var learnedSkills = [Int]()
    var equippedSkills = [BSActivatableSkill]()
    
    
    
}




