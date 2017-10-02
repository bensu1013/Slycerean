//
//  UnitActionReticle.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/14/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class DeprecatedUnitActionMenu: SKNode {
    
    override init() {
        super.init()
        
        self.position = CGPoint(x: 64, y: 64)
        self.zPosition = 400
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPosition(at tileCoord: TileCoord) {
        self.position = CGPoint(x: tileCoord.col * 128 + 64, y: tileCoord.row * 128 + 64)
    }
    
    func bloomActionItems(_ nodes: [ActionItem]) {
        for (count, node) in nodes.enumerated() {
            self.addChild(node)
            
            let itemDistance = Double.pi / 4
            let q = (Double(count) * itemDistance) - ( Double(nodes.count - 1) * itemDistance / 2 )
            let x = 128 * cos(q + Double.pi/2)
            let y = 128 * sin(q + Double.pi/2)
            animateActionItem(node, to: CGPoint(x: x, y: y))
        }
    }
    
    private func animateActionItem(_ node: ActionItem, to point: CGPoint) {
        let moveAction = SKAction.move(to: point, duration: 0.4)
        let fadeAction = SKAction.fadeAlpha(to: 1, duration: 0.4)
        node.run(moveAction)
        node.run(fadeAction)
    }
    
    func clearActionsItems(completion: @escaping ()->()) {
        for item in self.children {
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.4)
            let removeAction = SKAction.run { item.removeFromParent() }
            let sequence = SKAction.sequence([fadeAction, removeAction])
            item.run(sequence)
        }
        let waitAction = SKAction.wait(forDuration: 1)
        let completionAction = SKAction.run({ completion() })
        self.run(SKAction.sequence([waitAction,completionAction]))
    }
    
}

class ActionItem: SKButtonNode {
    
    
    
    required init() {
        super.init(normalTexture: SKTexture.init(imageNamed: "down_1"), selectedTexture: SKTexture.init(imageNamed: "up_1"), disabledTexture: SKTexture.init(imageNamed: "up_1"))
//        self.color = .blue
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextures(to texture: SKTexture) {
        
        self.defaultTexture = texture
        self.selectedTexture = texture
        self.disabledTexture = texture
        
    }
    
}







