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
        self.hasActed = false
        hasFinished = false
        self.unusedMovementSteps = totalMovementSteps
    }
    
    func newTurn() {
        self.hasActed = false
        self.unusedMovementSteps = totalMovementSteps
    }
    
    func endTurn() {
        self.hasFinished = true
    }

    
    func attackEventAndDamage(completion: @escaping ()->()) {
        hasActed = true
        completion()
    }
    
}




