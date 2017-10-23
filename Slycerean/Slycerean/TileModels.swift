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
        super.init(texture: texture, color: UIColor.clear, size: CGSize.init(width: 128, height: 128))
        self.name = name
        self.anchorPoint = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
enum HighlightType: String {
    case movementMain, movementStep, targetMain, targetSplash, blank
}
class HighlightSprite: SKSpriteNode {
    var visualNode: SKSpriteNode!
    var type: HighlightType
    
    init(type: HighlightType) {
        self.type = type
        super.init(texture: nil, color: .clear, size: CGSize.init(width: 128, height: 128))
        self.anchorPoint = .zero
        self.name = kObjectHighlightPath
        setupFor(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFor(type: HighlightType) {
        switch type {
        case .movementMain:
            setupForMovementMain()
        case .movementStep:
            setupForMovementStep()
        case .targetMain:
            setupForTargetMain()
        case .targetSplash:
            setupForTargetSplash()
        case .blank:
            setupForBlank()
        }
    }
    
    private func setupForMovementMain() {
        let panelTexture = SKTexture.init(imageNamed: "blue_panel")
        visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64) // Animating scaling requires a center anchor
        self.addChild(visualNode)
        animateBlinking(for: visualNode)
    }
    private func setupForMovementStep() {
        let panelTexture = SKTexture.init(imageNamed: "blue_panel")
        visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64) // Animating scaling requires a center anchor
        self.addChild(visualNode)
    }
    private func setupForTargetMain() {
        let panelTexture = SKTexture.init(imageNamed: "red_panel")
        visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64) // Animating scaling requires a center anchor
        self.addChild(visualNode)
        animateBlinking(for: visualNode)
    }
    private func setupForTargetSplash() {
        let panelTexture = SKTexture.init(imageNamed: "green_panel")
        visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64) // Animating scaling requires a center anchor
        self.addChild(visualNode)
    }
    private func setupForBlank() {
        visualNode = SKSpriteNode()
    }
    private func animateBlinking(for node: SKNode) {
        if let _ = action(forKey: "blinking") { return }
        
        let sizeDown = SKAction.scale(to: 0.9, duration: 0.2)
        let alphaDown = SKAction.fadeAlpha(to: 0.55, duration: 0.2)
        
        let seqDown = SKAction.sequence([sizeDown, alphaDown])
        
        let sizeUp = SKAction.scale(to: 1.0, duration: 0.2)
        let alphaUp = SKAction.fadeAlpha(to: 0.65, duration: 0.2)
        
        let seqUp = SKAction.sequence([sizeUp, alphaUp])
        
        let repeatAction = SKAction.repeatForever(SKAction.sequence([seqDown, seqUp]))
        
        node.run(repeatAction, withKey: "blinking")
    }
    
}



