//
//  HealthBarComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/30/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class StatusBarComponent: SKNode {
    
    internal var baseBar = SKSpriteNode()
    internal var visibleBar = SKSpriteNode()
    
    var width: CGFloat {
        return baseBar.size.width
    }
    var height: CGFloat {
        return baseBar.size.height
    }
    
    init(color: UIColor) {
        super.init()
        
        baseBar.size = CGSize(width: 120, height: 15)
        baseBar.color = .black
        baseBar.alpha = 0.8
        baseBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        baseBar.position = .zero
        addChild(baseBar)
        
        visibleBar.size = CGSize(width: 120, height: 15)
        visibleBar.color = color
        visibleBar.alpha = 1.0
        visibleBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        visibleBar.position = .zero
        visibleBar.zPosition = 2
        baseBar.addChild(visibleBar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateBarToScale(_ scale: CGFloat, duration: Double = 0.2) {
        visibleBar.run(SKAction.scaleX(to: scale, duration: duration))
    }
    
    
}
