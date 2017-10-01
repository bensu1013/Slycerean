//
//  HealthPointLabelComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/30/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class HealthPointStatusComponent: SKNode {
    weak var unit: GameUnit?
    
    var mainLabel = SKLabelNode()
    var healthBar = StatusBarComponent(color: .red)
    var currentAmoutLabel = SKLabelNode()
    var separatorLabel = SKLabelNode()
    var maximumAmountLabel = SKLabelNode()
    
    var fractionLabel = StatusFractionLabelComponent()
    
    override init() {
        super.init()
        
        mainLabel.text = "HP"
        mainLabel.fontColor = UIColor.black
        mainLabel.fontSize = 36
        mainLabel.fontName = "Optima-Bold"
        mainLabel.position = CGPoint.zero
        mainLabel.zPosition = 10
        mainLabel.horizontalAlignmentMode = .left
        mainLabel.verticalAlignmentMode = .center
        addChild(mainLabel)
        
        healthBar.position = CGPoint(x: mainLabel.position.x + mainLabel.frame.size.width + 5, y: 0)
        addChild(healthBar)
        
        fractionLabel.position = CGPoint(x: healthBar.position.x + healthBar.width + 5, y: 0)
        addChild(fractionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func displayNewUnit(_ unit: GameUnit) {
        self.unit = unit
        
        let scale = CGFloat(unit.currentHealthPoints) / CGFloat(unit.maximumHealthPoints)
        healthBar.animateBarToScale(scale, duration: 0)
        
        fractionLabel.updateUIForUnit(unit)
    }
    
    func updateUI() {
        guard let unit = unit else { return }
        fractionLabel.updateUIForUnit(unit)
        let scale = CGFloat(unit.currentHealthPoints) / CGFloat(unit.maximumHealthPoints)
        healthBar.animateBarToScale(scale)
    }
    
}

