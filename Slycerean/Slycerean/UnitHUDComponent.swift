//
//  UnitHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/28/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class UnitHUDComponent: SKNode {
    
    weak var unit: GameUnit?
    
    var backgroundCard: SKSpriteNode?
    var nameNode: SKLabelNode?
    var healthPointNode: HealthPointLabelComponent?
    var manaPointNode: SKSpriteNode?
    
    override init() {
        super.init()
        
        backgroundCard = SKSpriteNode(color: .orange, size: CGSize(width: 500, height: 300))
        backgroundCard?.alpha = 0.9
//        backgroundCard?.anchorPoint = .zero
        addChild(backgroundCard!)
        nameNode = SKLabelNode(text: "TempName")
        
        healthPointNode = HealthPointLabelComponent()
        healthPointNode?.position = CGPoint(x: -100, y: 0)
        addChild(healthPointNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HealthPointLabelComponent: SKNode {
    
    var mainLabel: SKLabelNode?
    var healthBar: SKSpriteNode?
    var currentAmoutLabel: SKLabelNode?
    var maximumAmountLabel: SKLabelNode?
    
    override init() {
        super.init()
        
        let mainLabelNode = SKLabelNode(text: "HP")
        mainLabel = mainLabelNode
        mainLabelNode.fontColor = UIColor.black
        mainLabelNode.position = CGPoint.zero
        mainLabelNode.zPosition = 10
        addChild(mainLabelNode)
        
        let healthBarNode = SKSpriteNode(color: .red, size: CGSize(width: 120, height: 15))
        healthBar = healthBarNode
        healthBarNode.position = CGPoint(x: 80, y: 15)
        healthBarNode.zPosition = 0
        addChild(healthBarNode)
        
        let currentAmountLabelNode = SKLabelNode(text: "50")
        currentAmoutLabel = currentAmountLabelNode
        currentAmountLabelNode.fontColor = UIColor.black
        currentAmountLabelNode.position = CGPoint(x: 160, y: 3)
        currentAmountLabelNode.zPosition = 10
        addChild(currentAmountLabelNode)
        
        let maximumAmountLabelNode = SKLabelNode(text: "/58")
        maximumAmountLabel = maximumAmountLabelNode
        maximumAmountLabelNode.fontColor = UIColor.black
        maximumAmountLabelNode.position = CGPoint(x: 165 + currentAmountLabelNode.frame.size.width, y: -3)
        maximumAmountLabelNode.zPosition = 12
        addChild(maximumAmountLabelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}













