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
    
    var hasMoved    = false
    var hasAttacked = false
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
    
    
    init(scene: GameScene) {
        tileCoord = TileCoord(col: 1, row: 1)
        self.scene = scene
        moveComponent = MoveComponent(for: self, in: scene)
        spriteComponent = SpriteComponent(unit: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareTurn() {
        if hasMoved && hasAttacked {
            // end turn
            // scene next unit's turn
            self.endTurn()
            return
        }
//        scene.gameBoard.activateTilesForMovement(for: self)
    }
    
    func endTurn() {
        self.hasMoved = false
        self.hasAttacked = false
        self.unusedMovementSteps = totalMovementSteps
    }
    
    @objc func walkActionSelected() {

    }
    
    @objc func attackActionSelected() {

    }
    
    @objc func cancelActionSelected() {
        self.endTurn()
    }
    
    @objc func mockAttackSkill() {
        self.hasAttacked = true
        scene.gameBoard.activateTilesForAction(for: self)

    }
    
    func attackEventAndDamage() {
        self.prepareTurn()
    }
    
}




