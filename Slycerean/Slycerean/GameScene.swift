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
 Observing the view seems to be the wrong approach for this game
 
 Arrays of structs should be used more abundantly as states of units or layers
 */


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
    
    var entities = [GKEntity]()
    var tempTurnIndex = 1
    
    var hudUIHook: UnitHUDComponent?
    var actUIHook: ActionHUDComponent?
    
    var currentActiveUnit: GameUnit?
    
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
        gameBoard.layer(type: .unit, insert: player.spriteComponent, at: player.tileCoord)
        
        player1 = GameUnit(scene: self)
        player1.spriteComponent.isUserInteractionEnabled = false
        player1.tileCoord = TileCoord(col: 2, row: 2)
        player1.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player1.spriteComponent, at: player1.tileCoord)
        
        
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
    
    // taprecognizer of view sent to scene to process
    func tapped(at point: CGPoint) {
        
        //taps should be handled in relation to the state of the scene
        
        let tileCoord = TPConvert.tileCoordForPosition(point)
        switch sceneState {
        case .readyMove:
            if gameBoard.layer(type: .highlight, hasObjectNamed: "move", at: tileCoord) {
                self.sceneState = .actionMove(tileCoord)
            }
            break
        case .readyAttack:
            if gameBoard.layer(type: .highlight, hasObjectNamed: "attack", at: tileCoord) {
                self.sceneState = .actionAttack(tileCoord)
            }
            break
        default:
            break
        }
        
    }
    
    private func prepareSceneFor(unit: GameUnit) {
        currentActiveUnit = unit
        unit.prepareTurn()
        hudUIHook?.setupHUDFor(unit: unit)
        actUIHook?.setupHUDFor(scene: self)
        gameCamera.move(to: unit.spriteComponent.position, animated: true)
        self.sceneState = .inactive
    }
    
    func shiftSceneTo(state: SceneState) {
//        defer {
            gameBoard.deactivateHighlightTiles()
//        }
        switch state {
        case .inactive:
            stateChangedToInactive()
            break
        case .readyMove:
            stateChangedToReadyMove()
            break
        case .actionMove(let tileCoord):
            currentActiveUnit?.moveComponent.moveTo(tileCoord) {
                self.sceneState = .inactive
            }
            break
        case .readyAttack:
            gameBoard.activateTilesForAction(for: currentActiveUnit!)
            break
        case .actionAttack(let tileCoord):
            // figure out attack size
            // figure out units effected
            // resolve event
            // switch state
            
            
            //highlightnodes are being removed too early
            var highlightTiles: [TileCoord] = []
            for node in gameBoard.getAllChildrenInLayer(type: .highlight) {
                highlightTiles.append(TPConvert.tileCoordForPosition(node.position))
            }
            
            var arTar: [GameUnit] = []
            
            if highlightTiles.contains(player.tileCoord) {
                arTar.append(player)
            } else if highlightTiles.contains(player1.tileCoord) {
                arTar.append(player1)
            }
            
            if arTar.isEmpty { return }
            currentActiveUnit?.attackEventAndDamage(units: arTar) {
                self.sceneState = .inactive
            }
            
            break
        case .turnEnd:
            currentActiveUnit?.endTurn()
            currentActiveUnit = nil
            self.sceneState = .inactive
            break
        }
        
    }
    
    func stateChangedToInactive() {
        hudUIHook?.updateUI()
        if let unit = currentActiveUnit {
            if unit.hasFinished {
                self.sceneState = .turnEnd
            } else {
                self.sceneState = .readyMove
            }
        } else {
            nextUnitTurn()
        }
    }
    
    func stateChangedToReadyMove() {
        gameBoard.activateTilesForMovement(for: currentActiveUnit!)
    }
    
}




