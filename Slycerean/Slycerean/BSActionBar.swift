//
//  BSActionBar.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/26/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSActionBar: SKSpriteNode {
    
    var actionNodes = [BSHUDActionSpriteNode]()
    
    required init(size: CGSize, buttonCount count: Int) {
        super.init(texture: nil, color: .brown, size: size)
        anchorPoint = .zero
        
        for i in 0..<count {
            let actionNode = BSHUDActionSpriteNode(texture: nil,
                                                     size: CGSize(width: 128, height: 128))
            actionNode.anchorPoint = .zero
            actionNode.position = CGPoint(x: 20 + (i * 148), y: 20)
            actionNode.type = ActionNodePosition(rawValue: i)!
            actionNodes.append(actionNode)
            addChild(actionNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadTextureForButton(withTexture texture: SKTexture, atIndex index: Int) {
        if index < actionNodes.count {
            actionNodes[index].texture = texture
        }
    }
    
    func loadTexturesForButtons(withTextures textures: [SKTexture]) {
        if actionNodes.count == textures.count {
            for i in 0..<actionNodes.count {
                actionNodes[i].texture = textures[i]
            }
        }
    }
    
    func tryTapping(onPoint point: CGPoint) -> ActionNodePosition? {
        for node in actionNodes {
            if node.contains(point) {
                return node.type
            }
        }
        return nil
    }
    
}
