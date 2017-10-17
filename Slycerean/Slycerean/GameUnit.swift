//
//  UnitEntity.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum UnitState {
    case ready, idle, move
}
enum Direction: String {
    case up, down, left, right
}



class GameUnit {
    weak var scene: GameScene!
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    
    var hasActed    = false
    var hasFinished = false 
    
    var tileCoord: TileCoord
    
    var firstName: String = "First"
    var lastName: String = "Last"
    
    var currentHealthPoints: Int = 32
    var maximumHealthPoints: Int = 32
    
    var unusedMovementSteps: Int = 4
    var totalMovementSteps: Int = 4
    
    var unusedMagicPowers = 2
    var totalMagicPowers = 2
    
    var chosenSkill: BSActivatableSkill?
    var equippedSkills = [BSActivatableSkill]()
    
    init(scene: GameScene) {
        tileCoord = TileCoord(col: 1, row: 1)
        self.scene = scene
        moveComponent = MoveComponent(for: self, in: scene)
        spriteComponent = SpriteComponent(unit: self)
        equippedSkills.append(BSFireballSkill())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareTurn() {
        hasActed = false
        hasFinished = false
        unusedMovementSteps = totalMovementSteps
    }
    
    func newTurn() {
        hasActed = false
        unusedMovementSteps = totalMovementSteps
    }
    
    func endTurn() {
        hasFinished = true
    }

    func attackEventAndDamage(units: [GameUnit], completion: @escaping ()->()) {
        chosenSkill?.useOnUnits(units, completion: {
            self.hasActed = true
            completion()
        })
    }
    
}




