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

    var spriteSheet: SpriteSheet
    var direction: Direction = .down
    
    init() {
        spriteSheet = SpriteSheet(texture: spriteTexture, columns: 6, rows: 3)
        super.init(texture: nil, color: .clear, size: CGSize(width: 128.0, height: 128.0))
        self.name = "Unit"
        texture = spriteSheet.getTextureFrom(col: 0, row: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func walk(_ direction: Direction, withKey: String) {
        if self.direction != direction {
            self.direction = direction
            removeAllActions()
            switch direction {
            case .down:
                let t1 = spriteSheet.getTextureFrom(col: 2, row: 0)
                let t2 = spriteSheet.getTextureFrom(col: 3, row: 0)
                run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
            case .up:
                let t1 = spriteSheet.getTextureFrom(col: 2, row: 1)
                let t2 = spriteSheet.getTextureFrom(col: 3, row: 1)
                run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
            case .left:
                let t1 = spriteSheet.getTextureFrom(col: 2, row: 2)
                let t2 = spriteSheet.getTextureFrom(col: 3, row: 2)
                anchorPoint = CGPoint(x: 0, y: 0)
                run(SKAction.scaleX(to: 1, duration: 0))
                run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
            case .right:
                let t1 = spriteSheet.getTextureFrom(col: 2, row: 2)
                let t2 = spriteSheet.getTextureFrom(col: 3, row: 2)
                anchorPoint = CGPoint(x: 1, y: 0)
                run(SKAction.scaleX(to: -1, duration: 0))
                run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
            }
        }
    }
    
}
