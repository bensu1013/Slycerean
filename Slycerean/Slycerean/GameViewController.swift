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
    
    let hud = UnitHUDComponent()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // figure out scene sized based on device width/height ratios to fix camera node positions
        let scene = GameScene.init(size: CGSize(width: 1920, height: 1280))
        scene.scaleMode = .aspectFill
        
        // Present the scene
        if let view = self.view as! SKView? {
            
            let camera = GameCamera(view: view, node: scene.masterNode)
            camera.overlay.addChild(hud)
            scene.setupCamera(camera)
            scene.hudUIHook = hud
            hud.position = CGPoint(x: -960, y: 540) // currently has height clipped to 1080 because of iphone7+ size
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
