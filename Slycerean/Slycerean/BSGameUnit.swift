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
    var name: String
    
    var health: Int
    var energy: Int
    
    var actionSpeed: Int
    var level: Int
    var job: BSGameUnitJob
}

struct BSCharacterEquipment {
    var weapon: String      // effects basic skill used, and damage dealt
    var armor: String       // effects damage reduction
    var relic: String       // special bonuses
}

class BSGameUnit {
    var equipment: BSCharacterEquipment
    
    var name: String
    
    var maximumHealth: Int
    var maximumEnergy: Int
    var maximumMovement: Int
    var actionSpeed: Int
    var attackPower: Int = 1
    var spellPower: Int = 1
    var job: BSGameUnitJob
    var basicAttack: BSActivatableSkill
    var equippedSkills = [BSActivatableSkill]()
    
    init(stats: BSCharacterStats, equipment: BSCharacterEquipment) {
        name = stats.name
        maximumHealth = stats.health
        maximumEnergy = stats.energy
        maximumMovement = 4
        actionSpeed = stats.actionSpeed
        job = stats.job
        self.equipment = equipment
        
        basicAttack = WarriorBasicSkill()
        equippedSkills.append(BSFireballSkill())
    }
    
}

class BSGameUnitSkillComponent {
    
    var learnedSkills = [Int]()
    var equippedSkills = [BSActivatableSkill]()
    
    
    
}




