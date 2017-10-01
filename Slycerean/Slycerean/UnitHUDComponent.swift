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
    
    weak var unit: GameUnit? {
        didSet{
            self.isHidden = unit == nil
        }
    }
    
    var backgroundCard: SKSpriteNode?
    var nameNode: SKLabelNode?
    var healthPointNode: HealthPointLabelComponent?
    var manaPointNode: SKSpriteNode?
    
    override init() {
        super.init()
        isHidden = true
        
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
    func setupHUDFor(unit: GameUnit) {
        self.unit = unit
        healthPointNode?.displayNewUnit(unit)
    }
    
    func updateUI() {
        healthPointNode?.updateUI()
    }
    
}













