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

typealias BSJobBaseStats = (str: Int, dex: Int, int: Int, vit: Int)

enum BSGameUnitJob {
    case warrior, wizard, ranger, rogue
    func getBaseStats() -> BSJobBaseStats {
        switch self {
        case .warrior:
            return (8,3,1,5)
        case .wizard:
            return (2,3,9,3)
        case .ranger:
            return (3,7,3,4)
        case .rogue:
            return (4,6,2,4)
        }
    }
}

struct BSCharacterStats {
    var health: Int
    var energy: Int
    
    var strength: Int
    var dexterity: Int
    var intellect: Int
    var vitality: Int
    
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
        return baseStats.health + (vitality * 2)
    }
    var maximumEnergy: Int {
        return baseStats.energy + (intellect * 1)
    }
    var maximumMovement: Int {
        return 4
    }
    var attackPower: Int = 4
    var spellPower: Int = 4
    
    
    // Total Stats depending on chosen class, base stats change
    var strength: Int       // increases physical melee damage, minor increase to range
    var dexterity: Int      // increases range damage, minor to melee
    var intellect: Int      // increases spell damage, increase casting energy
    var vitality: Int       // increases health and resist
    
    
    
    var basicAttack: BSActivatableSkill
    var equippedSkills = [BSActivatableSkill]()
    
    init(stats: BSCharacterStats, equipment: BSCharacterEquipment) {
        self.baseStats = stats
        self.equipment = equipment
        let jobStats = stats.job.getBaseStats()
        strength = jobStats.str + stats.strength
        dexterity = jobStats.dex + stats.dexterity
        intellect = jobStats.int + stats.intellect
        vitality = jobStats.vit + stats.vitality
        
        basicAttack = WarriorBasicSkill()
        equippedSkills.append(BSFireballSkill())
    }
    
}

class BSGameUnitSkillComponent {
    
    var learnedSkills = [Int]()
    var equippedSkills = [BSActivatableSkill]()
    
    
    
}




