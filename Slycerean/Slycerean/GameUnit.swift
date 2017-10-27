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
    func getBaseStats() -> BSJobBaseStats {
        switch self {
        case .warrior:
            return BSJobBaseStats(baseHealth: 32, baseMove: 3, baseMagic: 1, upHealth: 4, upMagic: 0, basicAttack: WarriorBasicSkill())
        case .wizard:
            return BSJobBaseStats(baseHealth: 16, baseMove: 3, baseMagic: 3, upHealth: 2, upMagic: 2, basicAttack: WizardBasicSkill())
        case .ranger:
            return BSJobBaseStats(baseHealth: 28, baseMove: 4, baseMagic: 2, upHealth: 3, upMagic: 1, basicAttack: RangerBasicSkill())
        case .rogue:
            return BSJobBaseStats(baseHealth: 22, baseMove: 5, baseMagic: 1, upHealth: 3, upMagic: 1, basicAttack: RogueBasicSkill())
        }
    }
}
struct BSJobBaseStats {
    var baseHealth: Int
    var baseMove: Int
    var baseMagic: Int
    
    var upHealth: Int
    var upMagic: Int
    
    var basicAttack: BSActivatableSkill
}

class GameUnit {

    var classJob: BSGameUnitJob
    var level: Int
    
    var firstName: String = "First"
    var lastName: String = "Last"
    
    var maximumHealth: Int
    var maximumMovement: Int
    var maximumMagic: Int
    
    var basicAttack: BSActivatableSkill
    var equippedSkills = [BSActivatableSkill]()
    
    init(job: BSGameUnitJob, level: Int) {
        self.classJob = job
        self.level = level
        let stats = job.getBaseStats()
        self.maximumHealth = stats.baseHealth + (stats.upHealth * level)
        self.maximumMovement = stats.baseMove
        self.maximumMagic = stats.baseMagic + (stats.upMagic * level)
        basicAttack = stats.basicAttack
        equippedSkills.append(BSFireballSkill())
    }
    
}

class BSGameUnitSkillComponent {
    
    var learnedSkills = [Int]()
    var equippedSkills = [BSActivatableSkill]()
    
    
    
}




