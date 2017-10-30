//
//  BSBasicSkills.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/30/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation


struct WarriorBasicSkill: BSActivatableSkill {
    var name = "WarriorBasicSkill"
    var skillType: BSSkillType = .basic
    
    var attackPattern = BSAttackPattern.init(pattern: .point, max: 1, min: 0)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -4
    
    func useOnUnits(_ units: [BSBattleUnit], completion: @escaping()->()) {
        animatedEffect {
            units.forEach({ (unit) in
                self.effectOnUnit(unit)
            })
            completion()
        }
    }
    
    func effectOnUnit(_ unit: BSBattleUnit) {
        unit.currentHealth += healthModifier
    }
    
    func animatedEffect(completion: @escaping ()->()) {
        completion()
    }
}

struct WizardBasicSkill: BSActivatableSkill {
    var name = "WizardBasicSkill"
    var skillType: BSSkillType = .basic
    
    var attackPattern = BSAttackPattern.init(pattern: .point, max: 3, min: 1)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -5
    
    func useOnUnits(_ units: [BSBattleUnit], completion: @escaping()->()) {
        animatedEffect {
            units.forEach({ (unit) in
                self.effectOnUnit(unit)
            })
            completion()
        }
    }
    
    func effectOnUnit(_ unit: BSBattleUnit) {
        unit.currentHealth += healthModifier
    }
    
    func animatedEffect(completion: @escaping ()->()) {
        completion()
    }
}

struct RangerBasicSkill: BSActivatableSkill {
    var name = "RangerBasicSkill"
    var skillType: BSSkillType = .basic
    
    var attackPattern = BSAttackPattern.init(pattern: .point, max: 4, min: 2)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -3
    
    func useOnUnits(_ units: [BSBattleUnit], completion: @escaping()->()) {
        animatedEffect {
            units.forEach({ (unit) in
                self.effectOnUnit(unit)
            })
            completion()
        }
    }
    
    func effectOnUnit(_ unit: BSBattleUnit) {
        unit.currentHealth += healthModifier
    }
    
    func animatedEffect(completion: @escaping ()->()) {
        completion()
    }
}

struct RogueBasicSkill: BSActivatableSkill {
    var name = "RogueBasicSkill"
    var skillType: BSSkillType = .basic
    
    var attackPattern = BSAttackPattern.init(pattern: .point, max: 1, min: 0)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -6
    
    func useOnUnits(_ units: [BSBattleUnit], completion: @escaping()->()) {
        animatedEffect {
            units.forEach({ (unit) in
                self.effectOnUnit(unit)
            })
            completion()
        }
    }
    
    func effectOnUnit(_ unit: BSBattleUnit) {
        unit.currentHealth += healthModifier
    }
    
    func animatedEffect(completion: @escaping ()->()) {
        completion()
    }
}
