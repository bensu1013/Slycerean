//
//  ActionHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/1/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

private enum ActionButtonType: String {
    case skillMenuAction, movementAction, endTurnAction
}

protocol ActionHUDDelegate {
    
}

class ActionHUDComponent: SKNode {
    
    weak var gameScene: GameScene?
    
    var actionButtons = [BSHUDActionSpriteNode]()
    
    override init() {
        super.init()
        
        let basicAttackButton = BSHUDActionSpriteNode(texture: SKTexture(imageNamed: "saber-slash"),
                                             size: CGSize(width: 128, height: 128))
        basicAttackButton.anchorPoint = CGPoint(x: 0, y: 1)
        basicAttackButton.position = CGPoint(x: 30, y: -30)
        basicAttackButton.type = .skillMenuAction
        actionButtons.append(basicAttackButton)
        addChild(basicAttackButton)
        
        let skillMenuButton = BSHUDActionSpriteNode(texture: SKTexture(imageNamed: "walking-boot"),
                                           size: CGSize(width: 128, height: 128))
        skillMenuButton.anchorPoint = CGPoint(x: 0, y: 1)
        skillMenuButton.position = CGPoint(x: 30, y: -188)//basicAttackButton.position.y - basicAttackButton.size.height - 30)
        skillMenuButton.type = .movementAction
        actionButtons.append(skillMenuButton)
        addChild(skillMenuButton)
        
        let endTurnButton = BSHUDActionSpriteNode(texture: SKTexture(imageNamed: "cancel"),
                                         size: CGSize(width: 128, height: 128))
        endTurnButton.anchorPoint = CGPoint(x: 0, y: 1)
        endTurnButton.position = CGPoint(x: 30, y: -336)//(skillMenuButton.position.y + skillMenuButton.size.height + 30))
        endTurnButton.type = .endTurnAction
        actionButtons.append(endTurnButton)
        addChild(endTurnButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHUDFor(scene: GameScene) {
        gameScene = scene
        
    }
    
    func tryTappingButton(onPoint point: CGPoint) -> Bool {
        for button in actionButtons {
            if button.contains(point) {
                switch button.type {
                case .skillMenuAction:
                    basicAttackAction()
                case .movementAction:
                    movementAction()
                case .endTurnAction:
                    endTurnAction()
                }
                return true
            }
        }
        return false
    }
    
    func basicAttackAction() {
        gameScene?.currentActiveUnit?.selectedBasicAttack()
        gameScene?.sceneState = .readyAttack
    }
    
    func movementAction() {
        gameScene?.sceneState = .readyMove
    }
    
    func skillMenuAction() {
        // expand menu take skills from
//        gameScene?.currentActiveUnit?.equippedSkills
        if let skills = gameScene?.currentActiveUnit?.equippedSkills {
            for _ in skills {
                
            }
        }
    }
    
    func endTurnAction() {
        gameScene?.sceneState = .turnEnd
    }
    
}

class BSHUDActionSpriteNode: SKSpriteNode {
    
    fileprivate var type: ActionButtonType = .skillMenuAction
    
}
