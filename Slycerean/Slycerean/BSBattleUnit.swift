//
//  BattleComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/23/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

class BSBattleUnit {
    weak var gameUnit: GameUnit?
    weak var scene: GameScene!
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    
    var currentHealth: Int
    var unusedMovement: Int
    var unusedMagic: Int
    var tileCoord: TileCoord
    
    var hasActed: Bool
    var hasFinished: Bool
    var selectedSkill: BSActivatableSkill?
    
    init(gameUnit: GameUnit, atCoord tileCoord: TileCoord, inScene scene: GameScene) {
        self.gameUnit = gameUnit
        self.currentHealth = gameUnit.maximumHealthPoints
        self.unusedMovement = gameUnit.totalMovementSteps
        self.unusedMagic = gameUnit.totalMagicPowers
        self.tileCoord = tileCoord
        self.hasActed = false
        self.hasFinished = false
        self.spriteComponent = SpriteComponent()
        self.moveComponent = MoveComponent(for: self, in: scene)
    }
    
    func prepareTurn() {
        guard let unit = gameUnit else { return }
        hasActed = false
        hasFinished = false
        unusedMovement = unit.totalMovementSteps
    }
    
    func endTurn() {
        hasFinished = true
        selectedSkill = nil
    }
    
    func attackEventAndDamage(units: [BSBattleUnit], completion: @escaping ()->()) {
        selectedSkill?.useOnUnits(units, completion: {
            self.hasActed = true
            completion()
        })
    }
    
}
