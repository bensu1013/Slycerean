//
//  AttackSkill.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/27/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

protocol ActivateSkill {
    func useOnUnits(_ units: [GameUnit], completion: @escaping()->())
    // targeted unit be effected dependant on skill used
    func effectOnUnit(_ unit: GameUnit)
    func animatedEffect(completion: @escaping ()->())
}

class BasicAttackSkill: ActivateSkill {
    
    var name = "BasicAttack"
    // different attack patterns come to mind
    // unit centered with choice of 'breaths'
    // range spaces filled for user to tap to cause aoe
//    var attackPattern =
    
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

enum AttackDirection {
    // Used to build an attack pattern
    case up(Int),down(Int),left(Int),right(Int)
    
}

struct BasicAttackPattern {
    
    /// Array represents an attack pattern
    let pattern: [AttackDirection] = [.up(2)]
    let distance: Int = 0
    
    
    
}






