//
//  BattleComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/23/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSBattleUnit {
    private var gameUnit: BSGameUnit
    weak var scene: BSBattleScene!
    var name: String {
        return gameUnit.name
    }
    
    var classJob: BSGameUnitJob {
        return gameUnit.job
    }
    
    var team: BSTeam = .user
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    
    var currentHealth: Int
    var maxHealth: Int {
        return gameUnit.maximumHealth
    }
    var maxMovement: Int {
        return gameUnit.maximumMovement
    }
    var unusedMagic: Int
    var maxMagic: Int {
        return gameUnit.maximumEnergy
    }
    var actionSpeedAccumulated: Int = 0
    var actionSpeed: Int {
        return gameUnit.actionSpeed
    }
    var equippedSkills: [BSActivatableSkill] {
        return gameUnit.equippedSkills
    }
    var tileCoord: TileCoord
    
    var hasMoved: Bool
    var hasActed: Bool
    var hasFinished: Bool
    var isDefeated: Bool
    var selectedSkill: BSActivatableSkill?
    
    init(gameUnit: BSGameUnit, atCoord tileCoord: TileCoord, inScene scene: BSBattleScene) {
        self.gameUnit = gameUnit
        self.currentHealth = gameUnit.maximumHealth
        self.unusedMagic = gameUnit.maximumEnergy
        self.tileCoord = tileCoord
        self.hasMoved = false
        self.hasActed = false
        self.hasFinished = false
        self.isDefeated = false
        self.spriteComponent = SpriteComponent(spriteSheet: BSSpriteLoader.shared.loadUnitSpriteSheet(for: gameUnit.job))
        self.moveComponent = MoveComponent(for: self, in: scene)
    }
    
    func selectedBasicAttack() {
        selectedSkill = gameUnit.basicAttack
    }
    
    func trySelectingSkill(atIndex index: Int) -> Bool {
        if index < equippedSkills.count {
            selectedSkill = equippedSkills[index]
            return true
        }
        return false
    }
    
    func prepareTurn() {
        hasMoved = false
        hasActed = false
        hasFinished = false
    }
    
    func endTurn() {
        hasFinished = true
        actionSpeedAccumulated = 0
        selectedSkill = nil
    }
    
    func attackEventAndDamage(units: [BSBattleUnit], completion: @escaping ()->()) {
        selectedSkill?.useOnUnits(units, completion: {
            self.hasActed = true
            completion()
        })
    }
    
}
