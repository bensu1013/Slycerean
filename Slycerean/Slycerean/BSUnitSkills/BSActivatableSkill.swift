//
//  AttackSkill.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/27/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

protocol BSActivatableSkill {
    var attackPattern: BSAttackPattern { get set }
    
    func useOnUnits(_ units: [GameUnit], completion: @escaping()->())
    // targeted unit be effected dependant on skill used
    func effectOnUnit(_ unit: GameUnit)
    func animatedEffect(completion: @escaping ()->())
}

class BasicAttackSkill: BSActivatableSkill {
    
    var name = "BasicAttack"

    var attackPattern = BSAttackPattern.init(pattern: .cross(3), max: 3, min: 1)
    
    /// amount of health change, negative for damage, positive for healing
    var healthModifier = -4
    
    
    func useOnUnits(_ units: [GameUnit], completion: @escaping()->()) {
        animatedEffect {
            units.forEach({ (unit) in
                self.effectOnUnit(unit)
            })
            completion()
        }
    }
    
    func effectOnUnit(_ unit: GameUnit) {
        unit.currentHealthPoints += healthModifier
    }
    
    func animatedEffect(completion: @escaping ()->()) {
        completion()
    }
    
}






