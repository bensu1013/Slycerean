//
//  TileModels.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/10/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit



class Tile: SKSpriteNode {
    
    init(name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HighlightSprite: SKNode {
    
    enum ActionType: String {
        case move, attack
    }
    
    weak var gameScene: GameScene?
    var visualNode: SKSpriteNode!
    var type: ActionType
    
    init(scene: GameScene, actionType: ActionType) {
        self.gameScene = scene
        self.type = actionType
        
        super.init()
        
        self.name = actionType.rawValue
        
        let panelTexture = type == .move ? SKTexture.init(imageNamed: "blue_panel") : SKTexture.init(imageNamed: "red_panel")
        visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64) // Animating scaling requires a center anchor
        self.addChild(visualNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateBlinking() {
        
        if let _ = action(forKey: "blinking") { return }
        
        let sizeDown = SKAction.scale(to: 0.9, duration: 0.2)
        let alphaDown = SKAction.fadeAlpha(to: 0.55, duration: 0.2)
        
        let seqDown = SKAction.sequence([sizeDown, alphaDown])
        
        let sizeUp = SKAction.scale(to: 1.0, duration: 0.2)
        let alphaUp = SKAction.fadeAlpha(to: 0.65, duration: 0.2)
        
        let seqUp = SKAction.sequence([sizeUp, alphaUp])
        
        let repeatAction = SKAction.repeatForever(SKAction.sequence([seqDown, seqUp]))
        
        visualNode?.run(repeatAction, withKey: "blinking")
        
    }
    
}



