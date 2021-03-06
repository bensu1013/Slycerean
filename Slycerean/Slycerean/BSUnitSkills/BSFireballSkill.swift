//
//  BSFireballSkill.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/16/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

class BSFireballSkill: BSActivatableSkill {
    
    var name = "Fireball"
    var skillType: BSSkillType = .damaging
    var attackPattern = BSAttackPattern.init(pattern: .cross(1), max: 5, min: 1)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -10
    
    
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
