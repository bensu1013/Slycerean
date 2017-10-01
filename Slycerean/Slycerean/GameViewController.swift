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
    
    var hud: UnitHUDComponent!
    var acthud: ActionHUDComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // figure out scene sized based on device width/height ratios to fix camera node positions
        let screenBounds = UIScreen.main.bounds
        
        let heightRatio = screenBounds.height / screenBounds.width
        
        let sceneWidth: CGFloat = 1920
        let sceneHeight: CGFloat = 1920 * heightRatio
        
        let scene = GameScene.init(size: CGSize(width: sceneWidth, height: sceneHeight))
        scene.scaleMode = .aspectFill
        
        hud = UnitHUDComponent(size: CGSize(width: sceneWidth / 3, height: sceneHeight / 4))
        acthud = ActionHUDComponent()
        
        // Present the scene
        if let view = self.view as! SKView? {
            
            let camera = GameCamera(view: view, node: scene.masterNode)
            camera.overlay.addChild(hud)
            camera.overlay.addChild(acthud)
            scene.setupCamera(camera)
            scene.hudUIHook = hud
            scene.actUIHook = acthud
            hud.position = CGPoint(x: -sceneWidth/2, y: sceneHeight/2)
            acthud.position = CGPoint(x: -sceneWidth/2, y: hud.position.y - hud.size.height)
            
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
