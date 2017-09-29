//
//  GameScene.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameBoard: GameBoard!
    var player: GameUnit!
    var player1: GameUnit!
    var gameCamera: GameCamera!
    var masterNode: SKNode!
    
    var entities = [GKEntity]()
    var tempTurnIndex = 1
    
    
    
    var unitTurn: GameUnit? {
        didSet {
            if unitTurn == nil {
                nextUnitTurn()
            }
        }
    }
    var userTurn: Bool = true {
        didSet {
            isUserInteractionEnabled = userTurn
        }
    }
    
    private var lastUpdateTime : TimeInterval = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {        
        
        masterNode = SKNode()
        
        //
//        masterNode.zRotation = 3.14/4
        addChild(masterNode)
        gameBoard = GameBoard(filename: "Level_0")
        masterNode.addChild(gameBoard)
        
        player = GameUnit(scene: self)
        player.spriteComponent.isUserInteractionEnabled = false
        player.tileCoord = TileCoord(col: 0, row: 2)
        player.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layerNamed(kLayerNamedUnit, insert: player.spriteComponent, at: player.tileCoord)
        
        player1 = GameUnit(scene: self)
        player1.spriteComponent.isUserInteractionEnabled = false
        player1.tileCoord = TileCoord(col: 2, row: 2)
        player1.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layerNamed(kLayerNamedUnit, insert: player1.spriteComponent, at: player1.tileCoord)
        
        unitTurn = player
        unitTurn!.prepareTurn()
    }
    
    func setupCamera() {
        self.addChild(gameCamera)
        self.camera = gameCamera
    }
    
//    var lastPanPosition: CGPoint?
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if lastPanPosition == nil {
//            lastPanPosition = touch.location(in: self)
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if let position = lastPanPosition {
//            let currentPanPosition = touch.location(in: self)
//            let diff = currentPanPosition - position
//            gameCamera.move(by: diff/CGPoint(x: 2, y: 2))
//            lastPanPosition = currentPanPosition
//        }
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lastPanPosition = nil
//    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime

        self.lastUpdateTime = currentTime
    }
    
    func nextUnitTurn() {
        if tempTurnIndex == 0 {
            tempTurnIndex = 1
            player.prepareTurn()
            unitTurn = player
            gameCamera.move(to: player.spriteComponent.position, animated: true)
        } else {
            tempTurnIndex = 0
            player1.prepareTurn()
            unitTurn = player1
            gameCamera.move(to: player1.spriteComponent.position, animated: true)
        }
        
    }
    
    

}




