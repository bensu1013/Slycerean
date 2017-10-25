//
//  BattleComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/23/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

let warriorTexture = SKTexture.init(imageNamed: "Character_Hero_Warrior")
let archerTexture = SKTexture.init(imageNamed: "Character_Hero_Archer")
let priestTexture = SKTexture.init(imageNamed: "Character_Hero_Priest")
let monsterTexture = SKTexture.init(imageNamed: "Character_Monster_Boss")

class BSBattleUnit {
    private weak var gameUnit: GameUnit?
//    weak var scene: GameScene!
    var name: String {
        let f = gameUnit?.firstName ?? ""
        let l = gameUnit?.lastName ?? ""
        return  f + " " + l
    }
    
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
        return gameUnit?.maximumMagic ?? 0
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
        self.unusedMagic = gameUnit.maximumMagic
        self.tileCoord = tileCoord
        self.hasActed = false
        self.hasFinished = false
        var texture: SKTexture
        switch gameUnit.classJob {
        case .warrior:
            texture = warriorTexture
        case .wizard:
            texture = priestTexture
        case .ranger:
            texture = archerTexture
        case .rogue:
            texture = monsterTexture
        }
        self.spriteComponent = SpriteComponent(spriteSheet: SpriteSheet(texture: texture, columns: 6, rows: 3))
        self.moveComponent = MoveComponent(for: self, in: scene)
    }
    
    func selectedBasicAttack() {
        selectedSkill = gameUnit?.basicAttack
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
