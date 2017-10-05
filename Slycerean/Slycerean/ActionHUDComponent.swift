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
    
    var basicAttackButton: ActionItem!
    var skillMenuButton: ActionItem!
    var endTurnButton: ActionItem!
    var actionButtons = [ActionItem]()
    
    override init() {
        super.init()
        
        basicAttackButton = ActionItem()
        basicAttackButton.setTextures(to: SKTexture(imageNamed: "saber-slash"))
        basicAttackButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(basicAttackAction))
        basicAttackButton.size = CGSize(width: 128, height: 128)
        basicAttackButton.anchorPoint = CGPoint(x: 0, y: 1)
        basicAttackButton.position = CGPoint(x: 30, y: -30)
        addChild(basicAttackButton)
        
        skillMenuButton = ActionItem()
        skillMenuButton.setTextures(to: SKTexture(imageNamed: "walking-boot"))
        skillMenuButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(skillMenuAction))
        skillMenuButton.size = CGSize(width: 128, height: 128)
        skillMenuButton.anchorPoint = CGPoint(x: 0, y: 1)
        skillMenuButton.position = CGPoint(x: 30, y: -(basicAttackButton.position.y + basicAttackButton.size.height + 30))
        addChild(skillMenuButton)
        
        endTurnButton = ActionItem()
        endTurnButton.setTextures(to: SKTexture(imageNamed: "cancel"))
        endTurnButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(endTurnAction))
        endTurnButton.size = CGSize(width: 128, height: 128)
        endTurnButton.anchorPoint = CGPoint(x: 0, y: 1)
        endTurnButton.position = CGPoint(x: 30, y: -(skillMenuButton.position.y + skillMenuButton.size.height + 30))
        addChild(endTurnButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHUDFor(scene: GameScene) {
        gameScene = scene
        
    }
    
    
    @objc func basicAttackAction() {
        gameScene?.shiftSceneTo(state: .readyAttack)
    }
    
    @objc func skillMenuAction() {
        // expand menu take skills from
        // gameScene?.unitTurn?.skills
        
    }
    
    @objc func endTurnAction() {
        gameScene?.shiftSceneTo(state: .turnEnd)
    }
    
}
