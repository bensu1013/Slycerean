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

class SpriteComponent: SKSpriteNode {

    var spriteSheet: SpriteSheet
    var direction: Direction = .down
    
    init(spriteSheet: SpriteSheet) {
        self.spriteSheet = spriteSheet
        super.init(texture: nil, color: .clear, size: CGSize(width: 128.0, height: 128.0))
        self.name = "Unit"
        let t1 = spriteSheet.getTextureFrom(col: 2, row: 0)
        let t2 = spriteSheet.getTextureFrom(col: 3, row: 0)
        run(SKAction.repeatForever(SKAction.animate(with: [t1, t2], timePerFrame: 0.5)))
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
