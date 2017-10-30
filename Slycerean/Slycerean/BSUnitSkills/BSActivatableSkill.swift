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
    var skillType: BSSkillType { get }
    func useOnUnits(_ units: [BSBattleUnit], completion: @escaping()->())
    // targeted unit be effected dependant on skill used
    func effectOnUnit(_ unit: BSBattleUnit)
    func animatedEffect(completion: @escaping ()->())
}

enum BSSkillType {
    case basic, damaging, healing
}
