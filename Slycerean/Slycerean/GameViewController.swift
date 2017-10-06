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
    var gameScene: GameScene!
    
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
        
        skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        let camera = GameCamera(view: skView, scene: gameScene)
        camera.overlay.addChild(hud)
        camera.overlay.addChild(acthud)
        gameScene.setupCamera(camera)
        gameScene.hudUIHook = hud
        gameScene.actUIHook = acthud
        hud.position = CGPoint(x: -sceneWidth/2, y: sceneHeight/2)
        acthud.position = CGPoint(x: -sceneWidth/2, y: hud.position.y - hud.size.height)
        
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
    
    /**
     Handler for double taps.
     - parameter recognizer: `UITapGestureRecognizer` tap gesture recognizer.
     */
    @objc func sceneTappedAction(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.ended) {
            let location = recognizer.location(in: recognizer.view)
            
            gameScene?.tapped(at: location)
            
        }
    }
    
}
