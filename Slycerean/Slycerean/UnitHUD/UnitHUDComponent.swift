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
    
    weak var gameScene: GameScene?
    
    weak var unit: BSBattleUnit? {
        didSet{
            self.isHidden = unit == nil
        }
    }
    
    var backgroundCard: SKSpriteNode?
    var nameNode: SKLabelNode?
    var healthPointNode: HealthPointStatusComponent?
    var manaPointNode: SKSpriteNode?
    var movePointNode: SKLabelNode?
    var size: CGSize
    
    required init(size: CGSize) {
        
        self.size = size
        
        super.init()
        isHidden = true
        
        backgroundCard = SKSpriteNode(color: .gray, size: size)
        backgroundCard?.alpha = 0.3
        backgroundCard?.anchorPoint = CGPoint(x: 0, y: 1)
        addChild(backgroundCard!)
        
        nameNode = SKLabelNode(text: "TempName")
        nameNode?.position = CGPoint(x: 30, y: -30)
        nameNode?.horizontalAlignmentMode = .left
        nameNode?.verticalAlignmentMode = .center
        nameNode?.fontSize = 40
        nameNode?.fontColor = .black
        nameNode?.fontName = "Optima-Bold"
        nameNode?.zPosition = 10
        addChild(nameNode!)
        
        healthPointNode = HealthPointStatusComponent()
        healthPointNode?.position = CGPoint(x: 25, y: -80)
        healthPointNode?.zPosition = 10
        addChild(healthPointNode!)
        
        movePointNode = SKLabelNode(text: "")
        movePointNode?.position = CGPoint(x: 25, y: -120)
        movePointNode?.horizontalAlignmentMode = .left
        movePointNode?.verticalAlignmentMode = .center
        movePointNode?.fontSize = 40
        movePointNode?.fontColor = .black
        movePointNode?.fontName = "Optima-Bold"
        addChild(movePointNode!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // showing a new unit
    func setupHUDFor(unit: BSBattleUnit) {
        self.unit = unit
        nameNode?.text = "\(unit.gameUnit!.firstName) \(unit.gameUnit!.lastName)"
        healthPointNode?.displayNewUnit(unit)
        movePointNode?.text = "\(unit.unusedMovement)"
    }
    
    func updateUI() {
        guard let unit = unit else { return }
        healthPointNode?.updateUI()
        movePointNode?.text = "\(unit.unusedMovement)"
    }
    
}













