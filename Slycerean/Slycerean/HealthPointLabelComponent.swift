//
//  HealthPointLabelComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/30/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class HealthPointLabelComponent: SKNode {
    weak var unit: GameUnit?
    
    var mainLabel = SKLabelNode()
    var healthBar = StatusBarComponent(color: .red)
    var currentAmoutLabel = SKLabelNode()
    var separatorLabel = SKLabelNode()
    var maximumAmountLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        mainLabel.text = "HP"
        mainLabel.fontColor = UIColor.black
        mainLabel.fontSize = 36
        mainLabel.fontName = "Optima"
        mainLabel.position = CGPoint.zero
        mainLabel.zPosition = 10
        mainLabel.horizontalAlignmentMode = .left
        mainLabel.verticalAlignmentMode = .center
        addChild(mainLabel)
        
        healthBar.position = CGPoint(x: mainLabel.position.x + mainLabel.frame.size.width + 5, y: 0)
        addChild(healthBar)
        
        currentAmoutLabel.fontColor = UIColor.black
        currentAmoutLabel.fontSize = 36
        currentAmoutLabel.fontName = "Optima"
        currentAmoutLabel.position = CGPoint(x: healthBar.position.x + healthBar.barWidth + 5, y: 3)
        currentAmoutLabel.zPosition = 10
        currentAmoutLabel.horizontalAlignmentMode = .left
        currentAmoutLabel.verticalAlignmentMode = .center
        addChild(currentAmoutLabel)
        
        separatorLabel.text = "/"
        separatorLabel.fontColor = UIColor.black
        separatorLabel.fontSize = 40
        separatorLabel.fontName = "Optima"
        separatorLabel.position = CGPoint(x: currentAmoutLabel.position.x + currentAmoutLabel.frame.size.width + 5, y: -2)
        separatorLabel.zPosition = 8
        separatorLabel.horizontalAlignmentMode = .left
        separatorLabel.verticalAlignmentMode = .center
        addChild(separatorLabel)
        
        maximumAmountLabel.fontColor = UIColor.black
        maximumAmountLabel.fontSize = 36
        maximumAmountLabel.fontName = "Optima"
        maximumAmountLabel.position = CGPoint(x: separatorLabel.position.x + separatorLabel.frame.size.width, y: -3)
        maximumAmountLabel.zPosition = 12
        maximumAmountLabel.horizontalAlignmentMode = .left
        maximumAmountLabel.verticalAlignmentMode = .center
        addChild(maximumAmountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func displayNewUnit(_ unit: GameUnit) {
        self.unit = unit
        currentAmoutLabel.text = "\(unit.currentHealthPoints)"
        separatorLabel.position = CGPoint(x: currentAmoutLabel.position.x + currentAmoutLabel.frame.size.width + 5, y: -2)
        maximumAmountLabel.text = "\(unit.maximumHealthPoints)"
        maximumAmountLabel.position = CGPoint(x: separatorLabel.position.x + separatorLabel.frame.size.width, y: -3)
        
        let scale = CGFloat(unit.currentHealthPoints) / CGFloat(unit.maximumHealthPoints)
        healthBar.animateBarToScale(scale, duration: 0)
    }
    
    func updateUI() {
        guard let unit = unit else { return }
        currentAmoutLabel.text = "\(unit.currentHealthPoints)"
        maximumAmountLabel.text = "\(unit.maximumHealthPoints)"
        let scale = CGFloat(unit.currentHealthPoints) / CGFloat(unit.maximumHealthPoints)
        healthBar.animateBarToScale(scale)
    }
    
}

