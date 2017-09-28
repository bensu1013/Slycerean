//
//  TileModels.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/10/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class TileCoord {
    var col: Int
    var row: Int
    init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    var top: TileCoord {
        return TileCoord(col: col, row: row + 1)
    }
    var left: TileCoord {
        return TileCoord(col: col - 1, row: row)
    }
    var right: TileCoord {
        return TileCoord(col: col + 1, row: row)
    }
    var bottom: TileCoord {
        return TileCoord(col: col, row: row - 1)
    }
    var topLeft: TileCoord {
        return TileCoord(col: col - 1, row: row + 1)
    }
    var topRight: TileCoord {
        return TileCoord(col: col + 1, row: row + 1)
    }
    var bottomLeft: TileCoord {
        return TileCoord(col: col - 1, row: row - 1)
    }
    var bottomRight: TileCoord {
        return TileCoord(col: col + 1, row: row - 1)
    }
    func at(direction: Direction) -> TileCoord {
        switch direction {
        case .up:
            return top
        case .down:
            return bottom
        case .left:
            return left
        case .right:
            return right
        }
    }
}

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
    
    enum ActionType: Int {
        case move, attack
    }
    
    weak var unit: GameUnit?
    var button: SKButtonNode?
    var visualNode: SKSpriteNode?
    var type: ActionType
    init(unit: GameUnit, actionType: ActionType) {
        
        self.unit = unit
        self.type = actionType
        
        super.init()
        
        self.name = kObjectHighlightPath
        let buttonNode = SKButtonNode(normalTexture: nil, selectedTexture: nil, disabledTexture: nil)
        buttonNode.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(buttonAction))
        buttonNode.zPosition = 500
        buttonNode.color = .clear
        buttonNode.anchorPoint = .zero
        self.addChild(buttonNode)
        self.button = buttonNode
        
        let panelTexture = type == .move ? SKTexture.init(imageNamed: "blue_panel") : SKTexture.init(imageNamed: "red_panel")
        let visualNode = SKSpriteNode(texture: panelTexture, color: .clear, size: CGSize.init(width: 128, height: 128))
        visualNode.alpha = 0.65
        visualNode.position = CGPoint(x: 64, y: 64)
        self.addChild(visualNode)
        self.visualNode = visualNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        switch self.type {
        case .move:
            self.unit?.scene.gameBoard.deactivateHighlightTiles()
            self.unit?.moveComponent?.moveTo(TPConvert.tileCoordForPosition(self.position))
        case .attack:
            self.unit?.scene.gameBoard.deactivateHighlightTiles()
            self.unit?.attackEventAndDamage()
        }
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



