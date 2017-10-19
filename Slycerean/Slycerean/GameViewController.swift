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
    var gameHud: BSGameHUD!
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
        
        gameHud = BSGameHUD(gameSceneSize: CGSize(width: sceneWidth, height: sceneHeight))
        
        skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        gameCamera = GameCamera(view: skView, scene: gameScene)
        gameCamera.overlay.addChild(gameHud)
        
        gameScene.setupCamera(gameCamera)
        gameScene.gameHud = gameHud
        
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
            
            let scenePoint = gameScene.convertPoint(fromView: location)
            
            gameScene?.tapped(at: scenePoint)
            
        }
    }
    
}
