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

//var spriteTextures: [String:[SKTexture]] = ["up":[SKTexture.init(imageNamed: "up_1"),
//                                                  SKTexture.init(imageNamed: "up_2"),
//                                                  SKTexture.init(imageNamed: "up_3")],
//                                            "down":[SKTexture.init(imageNamed: "down_1"),
//                                                    SKTexture.init(imageNamed: "down_2"),
//                                                    SKTexture.init(imageNamed: "down_3")],
//                                            "left":[SKTexture.init(imageNamed: "left_1"),
//                                                    SKTexture.init(imageNamed: "left_2"),
//                                                    SKTexture.init(imageNamed: "left_3")],
//                                            "right":[SKTexture.init(imageNamed: "right_1"),
//                                                     SKTexture.init(imageNamed: "right_2"),
//                                                     SKTexture.init(imageNamed: "right_3")]]

let spriteTexture = SKTexture.init(imageNamed: "Character_Hero_Warrior")

class SpriteComponent: SKSpriteNode {
    weak var unit: GameUnit?
    var direction: Direction = .down
    init(unit: GameUnit) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 128.0, height: 128.0))
        self.name = "Unit"
//        self.texture = SKTexture.init(rect: CGRect.init(x: 0, y: 200, width: 100, height: 100), in: spriteTexture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func walk(_ direction: Direction, withKey: String) {
        if self.direction != direction {
            self.direction = direction
            let x: CGFloat = 0
            var y: CGFloat
            switch direction {
            case .down:
                y = 0
            case .up:
                y = 1
            case .left:
                y = 2
//                xScale = xScale < 0 ? xScale * -1 : xScale
            case .right:
                y = 2
//                xScale = xScale > 0 ? xScale * -1 : xScale
            }

//            let t2 = SKTexture.init(rect: CGRect.init(x: spriteTexture.textureRect().maxX/(x+1),
//                                                      y: spriteTexture.textureRect().maxY/y,
//                                                      width: 100/spriteTexture.size().width,
//                                                      height: 100/spriteTexture.size().height), in: spriteTexture)
            
            removeAllActions()
            var textureRect = CGRect(x: x*(spriteTexture.size().width/6),
                                     y: y*(spriteTexture.size().height/3),
                                     width: spriteTexture.size().width/6,
                                     height: spriteTexture.size().height/3)
            
            textureRect = CGRect(x: textureRect.origin.x/spriteTexture.size().width,
                                 y: textureRect.origin.y/spriteTexture.size().height,
                                 width: textureRect.size.width/spriteTexture.size().width,
                                 height: textureRect.size.height/spriteTexture.size().height)
            
            let t1 = SKTexture(rect: textureRect, in: spriteTexture)
            
            textureRect = CGRect(x: (x+1)*(spriteTexture.size().width/6),
                                 y: y*(spriteTexture.size().height/3),
                                 width: spriteTexture.size().width/6,
                                 height: spriteTexture.size().height/3)
            
            textureRect = CGRect(x: textureRect.origin.x/spriteTexture.size().width,
                                 y: textureRect.origin.y/spriteTexture.size().height,
                                 width: textureRect.size.width/spriteTexture.size().width,
                                 height: textureRect.size.height/spriteTexture.size().height)
            
            let t2 = SKTexture(rect: textureRect, in: spriteTexture)
            
            run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
        }
        //runAnimation(with: spriteTextures[direction.rawValue]!, andKey: withKey)
    }
    
    
    private func runAnimation(with textures: [SKTexture], andKey key: String) {
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
        self.run(animate, withKey: key)
    }
    
    
}
