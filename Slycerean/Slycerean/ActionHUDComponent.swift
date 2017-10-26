//
//  ActionHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/1/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

protocol ActionHUDDelegate {
    
}

class ActionHUDComponent: SKNode {
    
    weak var gameScene: GameScene?
    
    var actionButtons = [SKSpriteNode]()
    
    override init() {
        super.init()
        
        let basicAttackButton = SKSpriteNode(texture: SKTexture(imageNamed: "saber-slash"),
                                             size: CGSize(width: 128, height: 128))
        basicAttackButton.anchorPoint = CGPoint(x: 0, y: 1)
        basicAttackButton.position = CGPoint(x: 30, y: -30)
        basicAttackButton.name = "basicAttack"
        actionButtons.append(basicAttackButton)
        addChild(basicAttackButton)
        
        let skillMenuButton = SKSpriteNode(texture: SKTexture(imageNamed: "walking-boot"),
                                           size: CGSize(width: 128, height: 128))
        skillMenuButton.anchorPoint = CGPoint(x: 0, y: 1)
        skillMenuButton.position = CGPoint(x: 30, y: -188)//basicAttackButton.position.y - basicAttackButton.size.height - 30)
        skillMenuButton.name = "skillMenu"
        actionButtons.append(skillMenuButton)
        addChild(skillMenuButton)
        
        let endTurnButton = SKSpriteNode(texture: SKTexture(imageNamed: "cancel"),
                                         size: CGSize(width: 128, height: 128))
        endTurnButton.anchorPoint = CGPoint(x: 0, y: 1)
        endTurnButton.position = CGPoint(x: 30, y: -336)//(skillMenuButton.position.y + skillMenuButton.size.height + 30))
        endTurnButton.name = "endTurn"
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
                if button.name == "basicAttack" {
                    basicAttackAction()
                } else if button.name == "skillMenu" {
                    skillMenuAction()
                } else if button.name == "endTurn" {
                    endTurnAction()
                }
                return true
            }
        }
        return false
    }
    
    @objc func basicAttackAction() {
        gameScene?.currentActiveUnit?.selectedBasicAttack()
        gameScene?.sceneState = .readyAttack
    }
    
    @objc func skillMenuAction() {
        // expand menu take skills from
//        gameScene?.currentActiveUnit?.equippedSkills
        if let skills = gameScene?.currentActiveUnit?.equippedSkills {
            for _ in skills {
                
            }
        }
        
    }
    
    @objc func endTurnAction() {
        gameScene?.sceneState = .turnEnd
    }
    
}
