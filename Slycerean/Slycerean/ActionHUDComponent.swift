//
//  ActionHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/1/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

private var ActionBarHeight: CGFloat = 180

enum ActionNodePosition: Int {
    case first,second,third,fourth
}

protocol ActionHUDDelegate {
    
}

class ActionHUDComponent: SKNode {
    
    weak var gameScene: GameScene?
    
    var isExpanded = false
    var actionButtons = [BSHUDActionSpriteNode]()
    
    var primaryActionBar = BSActionBar(size: CGSize(width: 612, height: ActionBarHeight), buttonCount: 4)
    var secondaryActionBar = BSActionBar(size: CGSize(width: 612, height: ActionBarHeight), buttonCount: 4)
    
    override init() {
        super.init()
        
        
        addChild(primaryActionBar)
        addChild(secondaryActionBar)
        
        let spriteLoader = BSSpriteLoader.shared
        
        primaryActionBar.loadTexturesForButtons(withTextures:
            [spriteLoader.loadIconTexture(forName: "Basic-Slash"),
             spriteLoader.loadIconTexture(forName: "Icon-Skills"),
             spriteLoader.loadIconTexture(forName: "Icon-Walk"),
             spriteLoader.loadIconTexture(forName: "Icon-Cancel")])

        secondaryActionBar.position = CGPoint(x: 0, y: -ActionBarHeight)
        secondaryActionBar.zPosition = -10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHUDFor(scene: GameScene) {
        gameScene = scene
        
    }
    
    func tryTappingButton(onPoint point: CGPoint) -> Bool {
        let primaryPoint = convert(point, to: primaryActionBar)
        if let position = primaryActionBar.tryTapping(onPoint: primaryPoint) {
            switch position {
            case .first:
                basicAttackAction()
            case .second:
                skillMenuAction()
            case .third:
                movementAction()
            case .fourth:
                endTurnAction()
            }
            return true
        }
        let secondaryPoint = convert(point, to: secondaryActionBar)
        if let position = secondaryActionBar.tryTapping(onPoint: secondaryPoint) {
            switch position {
            case .first:
                firstSkillAction()
            case .second:
                secondSkillAction()
            case .third:
                thirdSkillAction()
            case .fourth:
                fourthSkillAction()
            }
            return true
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
        isExpanded = true
        secondaryActionBar.run(SKAction.move(to: CGPoint(x: 0, y: ActionBarHeight) , duration: 0.2))
        let spriteLoader = BSSpriteLoader.shared
//        secondaryActionBar.loadTexturesForButtons(withTextures:
//            [spriteLoader.loadIconTexture(forName: "saber-slash"),
//             spriteLoader.loadIconTexture(forName: "saber-slash"),
//             spriteLoader.loadIconTexture(forName: "walking-boot"),
//             spriteLoader.loadIconTexture(forName: "cancel")])
        if let skills = gameScene?.currentActiveUnit?.equippedSkills {
            var c = 0
            for _ in skills {
                secondaryActionBar.loadTextureForButton(withTexture: spriteLoader.loadIconTexture(forName: "saber-slash"), atIndex: c)
                c += 1
            }
        }
    }
    
    func endTurnAction() {
        if isExpanded {
            secondaryActionBar.run(SKAction.move(to: CGPoint(x: 0, y: -ActionBarHeight), duration: 0.2))
        } else {
            gameScene?.sceneState = .turnEnd
        }
        isExpanded = false
    }
    
    func firstSkillAction() {
        
    }
    func secondSkillAction() {
        
    }
    func thirdSkillAction() {
        
    }
    func fourthSkillAction() {
        
    }
}

class BSHUDActionSpriteNode: SKSpriteNode {
    
    var type: ActionNodePosition = .first
    
}
