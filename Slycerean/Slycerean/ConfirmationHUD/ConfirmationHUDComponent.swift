//
//  ConfirmationHUDComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/16/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class ConfirmationHUDComponent: SKNode {
    
    
    var cancelNode: SKSpriteNode!
    var confirmNode: SKSpriteNode!

    
    required override init() {
        super.init()
        
        isHidden = true
        
        cancelNode = SKSpriteNode(texture: nil, color: .red, size: CGSize(width: 128, height: 64))
        cancelNode.alpha = 0.9
        cancelNode.anchorPoint = CGPoint(x: 1, y: 0.5)
        cancelNode.position = CGPoint(x: -20, y: 0)
        addChild(cancelNode)
        
        confirmNode = SKSpriteNode(texture: nil, color: .red, size: CGSize(width: 128, height: 64))
        confirmNode.alpha = 0.9
        confirmNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        confirmNode.position = CGPoint(x: 20, y: 0)
        addChild(confirmNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
