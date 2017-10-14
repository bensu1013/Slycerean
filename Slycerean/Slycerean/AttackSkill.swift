//
//  AttackSkill.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/27/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

protocol ActivatableSkill {
    var attackPattern: AttackPattern { get set }
    func useOnUnits(_ units: [GameUnit], completion: @escaping()->())
    // targeted unit be effected dependant on skill used
    func effectOnUnit(_ unit: GameUnit)
    func animatedEffect(completion: @escaping ()->())
}

class BasicAttackSkill: ActivatableSkill {
    
    var name = "BasicAttack"

    var attackPattern: AttackPattern = MeleeAttackPattern()
    
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

protocol AttackPattern {
    var pattern: AttackPatternStyle { get set }
    var distance: Int { get set }
}

enum AttackPatternStyle {
    // Used to build an attack pattern
    case cross(Int),square(Int),diamond(Int),point
}

struct MeleeAttackPattern: AttackPattern {
    /// Array represents an attack pattern
    var pattern: AttackPatternStyle = .cross(3)
    var distance: Int = 3
}

struct RangeAttackPattern: AttackPattern {
    var pattern: AttackPatternStyle = .point
    var distance: Int = 5
}




