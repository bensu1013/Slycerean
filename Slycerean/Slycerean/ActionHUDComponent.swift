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
    var endTurnButton: ActionItem!
    var actionButtons = [ActionItem]()
    
    override init() {
        super.init()
        
        basicAttackButton = ActionItem()
        basicAttackButton.setTextures(to: SKTexture(imageNamed: "saber-slash"))
        basicAttackButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(basicAttackAction))
        basicAttackButton.anchorPoint = CGPoint(x: 0, y: 1)
        basicAttackButton.position = CGPoint(x: 30, y: -30)
        addChild(basicAttackButton)
        
        endTurnButton = ActionItem()
        endTurnButton.setTextures(to: SKTexture(imageNamed: "cancel"))
        endTurnButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(endTurnAction))
        endTurnButton.anchorPoint = CGPoint(x: 0, y: 1)
        endTurnButton.position = CGPoint(x: 30, y: -120)
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
    
    @objc func endTurnAction() {
        gameScene?.shiftSceneTo(state: .turnEnd)
    }
    
}
