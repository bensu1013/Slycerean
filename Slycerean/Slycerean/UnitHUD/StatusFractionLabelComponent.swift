//
//  StatusFractionLabelComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/1/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class StatusFractionLabelComponent: SKNode {
    
    var currentAmoutLabel = SKLabelNode()
    var separatorLabel = SKLabelNode()
    var maximumAmountLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        currentAmoutLabel.fontColor = UIColor.black
        currentAmoutLabel.fontSize = 36
        currentAmoutLabel.fontName = "Optima-Bold"
        currentAmoutLabel.position = .zero
        currentAmoutLabel.zPosition = 10
        currentAmoutLabel.horizontalAlignmentMode = .left
        currentAmoutLabel.verticalAlignmentMode = .center
        addChild(currentAmoutLabel)
        
        separatorLabel.text = "/"
        separatorLabel.fontColor = UIColor.black
        separatorLabel.fontSize = 40
        separatorLabel.fontName = "Optima-Bold"
        separatorLabel.position = CGPoint(x: currentAmoutLabel.position.x + currentAmoutLabel.frame.size.width + 5, y: -2)
        separatorLabel.zPosition = 8
        separatorLabel.horizontalAlignmentMode = .left
        separatorLabel.verticalAlignmentMode = .center
        addChild(separatorLabel)
        
        maximumAmountLabel.fontColor = UIColor.black
        maximumAmountLabel.fontSize = 36
        maximumAmountLabel.fontName = "Optima-Bold"
        maximumAmountLabel.position = CGPoint(x: separatorLabel.position.x + separatorLabel.frame.size.width, y: -3)
        maximumAmountLabel.zPosition = 12
        maximumAmountLabel.horizontalAlignmentMode = .left
        maximumAmountLabel.verticalAlignmentMode = .center
        addChild(maximumAmountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUIForUnit(_ unit: BSBattleUnit) {
        currentAmoutLabel.text = "\(unit.currentHealth)"
        separatorLabel.position = CGPoint(x: currentAmoutLabel.position.x + currentAmoutLabel.frame.size.width + 5, y: -2)
        maximumAmountLabel.text = "\(unit.maxHealth)"
        maximumAmountLabel.position = CGPoint(x: separatorLabel.position.x + separatorLabel.frame.size.width, y: -3)
    }
    
}
