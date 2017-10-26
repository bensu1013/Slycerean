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
    
    var mainLabel:  SKLabelNode!
    var cancelNode: SKSpriteNode!
    var confirmNode: SKSpriteNode!
    
    required init(sceneSize: CGSize) {
        super.init()
        alpha = 0
        
        mainLabel = SKLabelNode()
        mainLabel.position = CGPoint(x: 0, y: 0)
        mainLabel.horizontalAlignmentMode = .center
        mainLabel.verticalAlignmentMode = .center
        mainLabel.color = UIColor.white.withAlphaComponent(0.4)
        mainLabel.fontColor = .black
        mainLabel.fontSize = 56
        mainLabel.fontName = "Optima-Bold"
        addChild(mainLabel)
        
        let buttonCenter = CGPoint(x: sceneSize.width/3, y: -sceneSize.height/3)
        let buttonSize = CGSize(width: 160, height: 96)
        
        cancelNode = SKSpriteNode(texture: nil, color: .red, size: buttonSize)
        cancelNode.alpha = 1.0
        cancelNode.position = CGPoint(x: buttonCenter.x - buttonSize.width/2 - 15, y: buttonCenter.y)
        addChild(cancelNode)
        
        let cancelLabel = SKLabelNode(text: "Cancel")
        cancelLabel.horizontalAlignmentMode = .center
        cancelLabel.verticalAlignmentMode = .center
        cancelLabel.fontColor = .black
        cancelLabel.fontSize = 32
        cancelLabel.fontName = "Optima-Bold"
        cancelNode.addChild(cancelLabel)
        
        confirmNode = SKSpriteNode(texture: nil, color: .green, size: buttonSize)
        confirmNode.alpha = 1.0
        confirmNode.position = CGPoint(x: buttonCenter.x + buttonSize.width/2 + 15, y: buttonCenter.y)
        addChild(confirmNode)
        
        let confirmLabel = SKLabelNode(text: "Confirm")
        confirmLabel.horizontalAlignmentMode = .center
        confirmLabel.verticalAlignmentMode = .center
        confirmLabel.fontColor = .black
        confirmLabel.fontSize = 32
        confirmLabel.fontName = "Optima-Bold"
        confirmNode.addChild(confirmLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Three cases for yes, no or didnt tap
    func tryConfirmWithTap(on point: CGPoint) -> Bool? {
        if cancelNode.contains(point) {
            cancelTapped()
            return false
        }
        if confirmNode.contains(point) {
            confirmTapped()
            return true
        }
        return nil
    }
    
    func cancelTapped() {
        cancelNode.run(popBounceAction())
    }
    
    func confirmTapped() {
        confirmNode.run(popBounceAction())
    }
    
    private func popBounceAction() -> SKAction {
        let size1 = SKAction.scale(to: 0.8, duration: 0.03)
        let size2 = SKAction.scale(to: 1.1, duration: 0.1)
        let size3 = SKAction.scale(to: 0.95, duration: 0.05)
        let size4 = SKAction.scale(to: 1.0, duration: 0.03)
        let done = SKAction.run({ self.hideAlert() })
        let sequence = SKAction.sequence([size1, size2, size3, size4, done])
        return sequence
    }
    
    func showAlert(titled title: String) {
        mainLabel.text = title
        run(SKAction.fadeAlpha(to: 1.0, duration: 0.1))
    }
    
    func hideAlert() {
        run(SKAction.fadeAlpha(to: 0.0, duration: 0.1))
    }
    
}
