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

protocol ActionHUDButtonDelegate: class {
    func firstSkillAction()
    func secondSkillAction()
    func thirdSkillAction()
    func fourthSkillAction()
    
    func basicSkillAction()
    func skillsForUnit() -> [BSActivatableSkill]
    func movementAction()
    func endTurnAction()
}

class ActionHUDComponent: SKNode {
    
    weak var delegate: ActionHUDButtonDelegate?
    
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
    
    func setupHUDWith(delegate: ActionHUDButtonDelegate) {
        self.delegate = delegate
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
        delegate?.basicSkillAction()
    }
    
    func movementAction() {
        delegate?.movementAction()
    }
    
    func skillMenuAction() {
        isExpanded = true
        secondaryActionBar.run(SKAction.move(to: CGPoint(x: 0, y: ActionBarHeight) , duration: 0.2))
        let spriteLoader = BSSpriteLoader.shared

        if let skills = delegate?.skillsForUnit() {
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
            delegate?.endTurnAction()
        }
        isExpanded = false
    }
    
    func firstSkillAction() {
        delegate?.firstSkillAction()
    }
    func secondSkillAction() {
        delegate?.secondSkillAction()
    }
    func thirdSkillAction() {
        delegate?.thirdSkillAction()
    }
    func fourthSkillAction() {
        delegate?.fourthSkillAction()
    }
}

class BSHUDActionSpriteNode: SKSpriteNode {
    var type: ActionNodePosition = .first
}
