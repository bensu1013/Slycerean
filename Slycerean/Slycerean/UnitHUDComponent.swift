//
//  UnitHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/28/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

/*  Everything in the UnitHUDComponent node
 *  should be positioned under the assumption that the main node
 *  is anchored at the top left corner
 *
 *  To make is simpler, when adding new components, have their anchor points
 *  also start on the left instead of center
 */
class UnitHUDComponent: SKNode {
    
    weak var unit: GameUnit?
    
    var backgroundCard: SKSpriteNode?
    var nameNode: SKLabelNode?
    var healthPointNode: HealthPointLabelComponent?
    var manaPointNode: SKSpriteNode?
    
    override init() {
        super.init()
        
        backgroundCard = SKSpriteNode(color: .gray, size: CGSize(width: 500, height: 300))
        backgroundCard?.alpha = 0.2
        backgroundCard?.anchorPoint = CGPoint(x: 0, y: 1)
        addChild(backgroundCard!)
        nameNode = SKLabelNode(text: "TempName")
        
        healthPointNode = HealthPointLabelComponent()
        healthPointNode?.position = CGPoint(x: 10, y: -120)
        addChild(healthPointNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // showing a new unit
    func setupHUDFor() {//}(unit: GameUnit) {
        // self.unit = unit
    }
    
    func updateUI() {
        healthPointNode?.updateUI()
    }
    
}

class HealthPointLabelComponent: SKNode {
    var mainLabel: SKLabelNode?
    var healthBar: SKSpriteNode?
    var currentAmoutLabel: SKLabelNode?
    var separatorLabel: SKLabelNode?
    var maximumAmountLabel: SKLabelNode?
    
    override init() {
        super.init()
        
        let mainLabelNode = SKLabelNode(text: "HP")
        mainLabel = mainLabelNode
        mainLabelNode.fontColor = UIColor.black
        mainLabelNode.fontSize = 36
        mainLabelNode.fontName = "Optima"
        mainLabelNode.position = CGPoint.zero
        mainLabelNode.zPosition = 10
        mainLabelNode.horizontalAlignmentMode = .left
        mainLabelNode.verticalAlignmentMode = .center
        addChild(mainLabelNode)
        
        let healthBarNode = SKSpriteNode(color: .red, size: CGSize(width: 120, height: 15))
        healthBar = healthBarNode
        healthBarNode.position = CGPoint(x: mainLabelNode.position.x + mainLabelNode.frame.size.width + 5, y: 0)
        healthBarNode.zPosition = 0
        healthBarNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        addChild(healthBarNode)
        
        let currentAmountLabelNode = SKLabelNode(text: "100")
        currentAmoutLabel = currentAmountLabelNode
        currentAmountLabelNode.fontColor = UIColor.black
        currentAmountLabelNode.fontSize = 36
        currentAmountLabelNode.fontName = "Optima"
        currentAmountLabelNode.position = CGPoint(x: healthBarNode.position.x + healthBarNode.frame.size.width + 5,
                                                  y: 3)
        currentAmountLabelNode.zPosition = 10
        currentAmountLabelNode.horizontalAlignmentMode = .left
        currentAmountLabelNode.verticalAlignmentMode = .center
        addChild(currentAmountLabelNode)
        
        let separatorLabelNode = SKLabelNode(text: "/")
        separatorLabel = separatorLabelNode
        separatorLabelNode.fontColor = UIColor.black
        separatorLabelNode.fontSize = 40
        separatorLabelNode.fontName = "Optima"
        separatorLabelNode.position = CGPoint(x: currentAmountLabelNode.position.x + currentAmountLabelNode.frame.size.width + 5,
                                              y: -2)
        separatorLabelNode.zPosition = 8
        separatorLabelNode.horizontalAlignmentMode = .left
        separatorLabelNode.verticalAlignmentMode = .center
        addChild(separatorLabelNode)
        
        let maximumAmountLabelNode = SKLabelNode(text: "158")
        maximumAmountLabel = maximumAmountLabelNode
        maximumAmountLabelNode.fontColor = UIColor.black
        maximumAmountLabelNode.fontSize = 36
        maximumAmountLabelNode.fontName = "Optima"
        // using its own width since current amount may be less digits than the maximum amount
        maximumAmountLabelNode.position = CGPoint(x: separatorLabelNode.position.x + separatorLabelNode.frame.size.width,
                                                  y: -3)
        maximumAmountLabelNode.zPosition = 12
        maximumAmountLabelNode.horizontalAlignmentMode = .left
        maximumAmountLabelNode.verticalAlignmentMode = .center
        addChild(maximumAmountLabelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var curHealth = 162
    
    func updateUI() {
        curHealth -= 3
        mainLabel?.text = "HP"
        currentAmoutLabel?.text = "\(curHealth)"
        maximumAmountLabel?.text = "162"
        
    }
    
}













