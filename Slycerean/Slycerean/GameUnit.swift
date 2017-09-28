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
    
    var actionItems = [ActionItem]()
    var selectedAction: ActionItem?
    
    var spriteComponent: SpriteComponent!
    var moveComponent: MoveComponent!
    
    var hasMoved    = false
    var hasAttacked = false
    var hasFinished = false
    
    var tileCoord: TileCoord
    
    var moveSpaces: Int = 4
    
    init(scene: GameScene) {
        tileCoord = TileCoord(col: 1, row: 1)
        self.scene = scene
        moveComponent = MoveComponent(for: self, in: scene)
        spriteComponent = SpriteComponent(unit: self)
        
        let moveItem = ActionItem()
        moveItem.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(walkActionSelected))
        self.actionItems.append(moveItem)
        let attackItem = ActionItem()
        attackItem.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(attackActionSelected))
        self.actionItems.append(attackItem)
        let cancelItem = ActionItem()
        cancelItem.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(cancelActionSelected))
        self.actionItems.append(cancelItem)
        
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
        
        self.actionItems[0].isEnabled = !hasMoved
        self.actionItems[1].isEnabled = !hasAttacked
        
        // each action should come from actions available to the unit
        scene.gameBoard.unitActionMenu.setPosition(at: self.tileCoord)
        scene.gameBoard.unitActionMenu.bloomActionItems(actionItems)
    }
    
    func endTurn() {
        self.hasMoved = false
        self.hasAttacked = false
        self.scene.gameBoard.unitActionMenu.clearActionsItems {
            self.scene.unitTurn = nil
        }
    }
    
    @objc func walkActionSelected() {
        scene.gameBoard.activateTilesForMovement(for: self)
        scene.gameBoard.unitActionMenu.clearActionsItems {
            
        }
    }
    
    @objc func attackActionSelected() {
        scene.gameBoard.unitActionMenu.clearActionsItems {
            let attack = ActionItem()
            attack.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.mockAttackSkill))
            self.scene.gameBoard.unitActionMenu.bloomActionItems([attack])
        }
    }
    
    @objc func cancelActionSelected() {
        self.endTurn()
    }
    
    @objc func mockAttackSkill() {
        self.hasAttacked = true
        scene.gameBoard.activateTilesForAction(for: self)
        scene.gameBoard.unitActionMenu.clearActionsItems {
            
        }
    }
    
    func attackEventAndDamage() {
        self.prepareTurn()
    }
    
}




