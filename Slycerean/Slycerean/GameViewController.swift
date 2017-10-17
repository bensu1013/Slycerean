//
//  GameViewController.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var skView: SKView!
    var hud: UnitHUDComponent!
    var acthud: ActionHUDComponent!
    var confirmhud: ConfirmationHUDComponent!
    var gameScene: GameScene!
    var gameCamera: GameCamera!
    

    
    /// Gesture recognizer to recognize double taps
    public var sceneTappedGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // figure out scene sized based on device width/height ratios to fix camera node positions
        let screenBounds = UIScreen.main.bounds
        
        let heightRatio = screenBounds.height / screenBounds.width
        
        let sceneWidth: CGFloat = 1920
        let sceneHeight: CGFloat = 1920 * heightRatio
        
        gameScene = GameScene.init(size: CGSize(width: sceneWidth, height: sceneHeight))
        gameScene.scaleMode = .aspectFill
        
        hud = UnitHUDComponent(size: CGSize(width: sceneWidth / 3, height: sceneHeight / 4))
        acthud = ActionHUDComponent()
        confirmhud = ConfirmationHUDComponent()
        
        skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        gameCamera = GameCamera(view: skView, scene: gameScene)
        gameCamera.overlay.addChild(hud)
        gameCamera.overlay.addChild(acthud)
        gameCamera.overlay.addChild(confirmhud)
        
        gameScene.setupCamera(gameCamera)
        gameScene.hudUIHook = hud
        gameScene.actUIHook = acthud
        gameScene.confirmUIHook = confirmhud
        
        hud.position = CGPoint(x: -sceneWidth/2, y: sceneHeight/2)
        acthud.position = CGPoint(x: -sceneWidth/2, y: hud.position.y - hud.size.height)
        confirmhud.position = .zero
        
        
        
        
        
        
        
        skView.presentScene(gameScene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        sceneTappedGesture = UITapGestureRecognizer(target: self, action: #selector(sceneTappedAction))
        sceneTappedGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(sceneTappedGesture)
        
        gameScene.nextUnitTurn()
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func sceneTappedAction(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.ended) {
            
            let location = recognizer.location(in: skView)
            
            // cameraPoint isnt converting, need to look in to.
            let scenePoint = gameScene.convertPoint(fromView: location)
            let cameraPoint = gameScene.convert(scenePoint, to: acthud)
//            let cameraPoint = gameCamera.overlay.convert(location, to: gameCamera.overlay)
            
            let confirmPoint = gameScene.convert(scenePoint, to: confirmhud)
            if gameScene.isConfirming {
                if confirmhud.cancelNode.contains(confirmPoint) {
                    gameScene?.sceneState = .readyMove
                    gameScene?.isConfirming = false
                    confirmhud.isHidden = true
                } else if confirmhud.confirmNode.contains(confirmPoint) {
                    gameScene?.sceneState = .actionMove(gameScene.desiredMoveTile!)
                    gameScene?.desiredMoveTile = nil
                    gameScene?.isConfirming = false
                    confirmhud.isHidden = true
                }
                return
            }
            
            for node in acthud.actionButtons {
                if node.contains(cameraPoint) {
                    UIApplication.shared.sendAction(node.actionTouchUpInside!,
                                                    to: node.targetTouchUpInside,
                                                    from: node, for: nil)
                    return
                }
            }
            
            gameScene?.tapped(at: scenePoint)
            
        }
    }
    
}
