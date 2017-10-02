//
//  GameScene.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
 
 GameScene should be central access point for everything else
 HUD should relay any inputs to the scene to handle
 A turn are parts of the scene and how it is displayed
 
 
 In the event a new unit is chosen to take its turn
 - update HUD with unit
 @ Default State
 - nothing is shown on board
 @ Move Ready State
 - place movement tiles ( units can run out of movesteps )
 @ Movement State
 - unit moves
 @ Attack Ready State ( includes spells )
 - place attack tiles for chosen skill
 @ Attacking State
 - animate attacks, resolve attack
 @ TurnEnd State
 - clear and reset relevant objects choose new unitTurn
 */


enum SceneState {
    case inactive, readyMove, actionMove(TileCoord), readyAttack, actionAttack(TileCoord), turnEnd
}

class GameScene: SKScene {
    
    var sceneState: SceneState = .inactive {
        didSet {
            shiftSceneTo(state: sceneState)
        }
    }
    
    var gameBoard: GameBoard!
    var player: GameUnit!
    var player1: GameUnit!
    var gameCamera: GameCamera!
    var worldNode: SKNode!
    
    var entities = [GKEntity]()
    var tempTurnIndex = 1
    
    var hudUIHook: UnitHUDComponent?
    var actUIHook: ActionHUDComponent?
    
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
        
        gameBoard = GameBoard(scene: self, filename: "Level_0")
        addChild(gameBoard)
        
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
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unitTurn?.currentHealthPoints -= 3
        hudUIHook?.updateUI()
    }
    
    override func update(_ currentTime: TimeInterval) {
      
    }
    
    func setupCamera(_ gameCamera: GameCamera) {
        self.gameCamera = gameCamera
        self.addChild(gameCamera)
        self.camera = gameCamera
    }
    func nextUnitTurn() {
        if tempTurnIndex == 0 {
            tempTurnIndex = 1
            prepareSceneFor(unit: player)
        } else {
            tempTurnIndex = 0
            prepareSceneFor(unit: player1)
        }
    }
    
    private func prepareSceneFor(unit: GameUnit) {
        unitTurn = unit
        unit.prepareTurn()
        hudUIHook?.setupHUDFor(unit: unit)
        actUIHook?.setupHUDFor(scene: self)
        gameCamera.move(to: unit.spriteComponent.position, animated: true)
        shiftSceneTo(state: .readyMove)
    }
    
    func shiftSceneTo(state: SceneState) {
        gameBoard.deactivateHighlightTiles()
        switch state {
        case .inactive:
            break
        case .readyMove:
            stateChangedToReadyMove()
            break
        case .actionMove(let tileCoord):
            unitTurn?.moveComponent.moveTo(tileCoord) {
                self.shiftSceneTo(state: .readyMove)
            }
            break
        case .readyAttack:
            gameBoard.activateTilesForAction(for: unitTurn!)
            break
        case .actionAttack:
            unitTurn?.attackEventAndDamage()
            self.shiftSceneTo(state: .readyMove)
            break
        case .turnEnd:
            unitTurn?.endTurn()
            unitTurn = nil
            break
        }
    }
    
    func stateChangedToReadyMove() {
        gameBoard.activateTilesForMovement(for: unitTurn!)
    }
    
}




