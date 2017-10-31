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
    private weak var gameUnit: GameUnit?
//    weak var scene: GameScene!
    var name: String {
        let f = gameUnit?.firstName ?? ""
        let l = gameUnit?.lastName ?? ""
        return  f + " " + l
    }
    
    var classJob: BSGameUnitJob {
        return gameUnit?.baseStats.job ?? .warrior
    }
    
    var team: BSTeam = .user
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    
    var currentHealth: Int
    var maxHealth: Int {
        return gameUnit?.maximumHealth ?? 0
    }
    var unusedMovement: Int
    var maxMovement: Int {
        return gameUnit?.maximumMovement ?? 0
    }
    var unusedMagic: Int
    var maxMagic: Int {
        return gameUnit?.maximumEnergy ?? 0
    }
    var equippedSkills: [BSActivatableSkill] {
        return gameUnit?.equippedSkills ?? []
    }
    var tileCoord: TileCoord
    
    var hasActed: Bool
    var hasFinished: Bool
    var selectedSkill: BSActivatableSkill?
    
    init(gameUnit: GameUnit, atCoord tileCoord: TileCoord, inScene scene: GameScene) {
        self.gameUnit = gameUnit
        self.currentHealth = gameUnit.maximumHealth
        self.unusedMovement = gameUnit.maximumMovement
        self.unusedMagic = gameUnit.maximumEnergy
        self.tileCoord = tileCoord
        self.hasActed = false
        self.hasFinished = false
        self.spriteComponent = SpriteComponent(spriteSheet: BSSpriteLoader.shared.loadUnitSpriteSheet(for: gameUnit.baseStats.job))
        self.moveComponent = MoveComponent(for: self, in: scene)
    }
    
    func selectedBasicAttack() {
        selectedSkill = gameUnit?.basicAttack
    }
    
    func trySelectingSkill(atIndex index: Int) -> Bool {
        if index < equippedSkills.count {
            selectedSkill = equippedSkills[index]
            return true
        }
        return false
    }
    
    func prepareTurn() {
        guard let unit = gameUnit else { return }
        hasActed = false
        hasFinished = false
        unusedMovement = unit.maximumMovement
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
