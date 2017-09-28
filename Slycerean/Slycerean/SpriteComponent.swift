//
//  SpriteComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

var spriteTextures: [String:[SKTexture]] = ["up":[SKTexture.init(imageNamed: "up_1"),
                                                  SKTexture.init(imageNamed: "up_2"),
                                                  SKTexture.init(imageNamed: "up_3")],
                                            "down":[SKTexture.init(imageNamed: "down_1"),
                                                    SKTexture.init(imageNamed: "down_2"),
                                                    SKTexture.init(imageNamed: "down_3")],
                                            "left":[SKTexture.init(imageNamed: "left_1"),
                                                    SKTexture.init(imageNamed: "left_2"),
                                                    SKTexture.init(imageNamed: "left_3")],
                                            "right":[SKTexture.init(imageNamed: "right_1"),
                                                     SKTexture.init(imageNamed: "right_2"),
                                                     SKTexture.init(imageNamed: "right_3")]]

class SpriteComponent: SKSpriteNode {
    weak var unit: GameUnit?
    
    init(unit: GameUnit) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 128.0, height: 128.0))
        self.name = "Unit"
        self.texture = spriteTextures["down"]![0]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func walk(_ direction: Direction, withKey: String) {
        runAnimation(with: spriteTextures[direction.rawValue]!, andKey: withKey)
    }
    
    private func runAnimation(with textures: [SKTexture], andKey key: String) {
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        self.run(animate, withKey: key)
    }
    
    
}
