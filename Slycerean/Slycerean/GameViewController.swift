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
        
        let scene = GameScene.init(size: CGSize(width: 1500, height: 1000))
        scene.scaleMode = .aspectFill
        
        // Present the scene
        if let view = self.view as! SKView? {
            
            let camera = GameCamera(view: view, node: scene.masterNode)
            hud.position = CGPoint(x: -750, y: 500)
            camera.overlay.addChild(hud)
            scene.setupCamera(camera)
            
            scene.hudUIHook = hud
            
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
