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
    case inactive, readyMove, confirmMove(TileCoord), actionMove(TileCoord), readyAttack, confirmAttack(TileCoord), actionAttack(TileCoord), turnEnd
}

class GameScene: SKScene {
    
    var sceneState: SceneState = .inactive {
        didSet {
            shiftSceneTo(state: sceneState)
        }
    }
    
    var gameBoard: GameBoard!

    var gameCamera: GameCamera!
    var unitEntities = [GameUnit]()
    var tempTurnIndex = 0
    
    weak var gameHud: BSGameHUD?
    var currentActiveUnit: GameUnit?
    
    var isConfirming = false
    var desiredMoveTile: TileCoord?
    
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
        
        let player = GameUnit(scene: self)
        player.spriteComponent.isUserInteractionEnabled = false
        player.tileCoord = TileCoord(col: 0, row: 2)
        player.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player.spriteComponent, at: player.tileCoord)
        unitEntities.append(player)
        
        let player1 = GameUnit(scene: self)
        player1.spriteComponent.isUserInteractionEnabled = false
        player1.tileCoord = TileCoord(col: 2, row: 2)
        player1.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player1.spriteComponent, at: player1.tileCoord)
        unitEntities.append(player1)
        
        let player2 = GameUnit(scene: self)
        player2.spriteComponent.isUserInteractionEnabled = false
        player2.tileCoord = TileCoord(col: 5, row: 5)
        player2.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player2.spriteComponent, at: player2.tileCoord)
        unitEntities.append(player2)
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func setupCamera(_ gameCamera: GameCamera) {
        self.gameCamera = gameCamera
        self.addChild(gameCamera)
        self.camera = gameCamera
    }
    
    func nextUnitTurn() {
        prepareSceneFor(unit: unitEntities[tempTurnIndex])
        tempTurnIndex = tempTurnIndex + 1 >= unitEntities.count ? 0 : tempTurnIndex + 1
    }
    
    // taprecognizer of view sent to scene to process
    func tapped(at point: CGPoint) {
        guard let gameHud = gameHud else { return }
        
        // cameraPoint isnt converting, need to look in to.
        let cameraPoint = self.convert(point, to: gameHud.actionMenuComponent)
        if gameHud.tryActionWithTap(on: cameraPoint) {
            return
        }
        
        //taps should be handled in relation to the state of the scene
        
        let tileCoord = TPConvert.tileCoordForPosition(point)
        switch sceneState {
        case .readyMove:
            if gameBoard.layer(type: .highlight, hasObjectNamed: HighlightType.movementStep.rawValue, at: tileCoord) {
                sceneState = .confirmMove(tileCoord)
            }
            break
        case .confirmMove(let tileCoord):
            let confirmPoint = self.convert(point, to: gameHud.confirmationComponent)
            guard let tapped = gameHud.tryConfirmWithTap(on: confirmPoint) else { return }
            if tapped {
                sceneState = .actionMove(tileCoord)
            } else {
                sceneState = .readyMove
            }
            break
        case .readyAttack:
            if gameBoard.layer(type: .highlight, hasObjectNamed: HighlightType.targetMain.rawValue, at: tileCoord) {
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
        gameHud?.setSelectedUnitHud(with: unit)
        gameHud?.setGameScene(self)
        gameCamera.move(to: unit.spriteComponent.position, animated: true)
        self.sceneState = .inactive
    }
    
    func shiftSceneTo(state: SceneState) {
        gameBoard.deactivateHighlightTiles()
        switch state {
        case .inactive:
            stateChangedToInactive()
            break
        case .readyMove:
            stateChangedToReadyMove()
            break
        case .confirmMove(let tileCoord):
            gameBoard.removeAllChildrenInLayer(type: .highlight)
            gameBoard.layer(type: .highlight, insert: HighlightSprite.init(type: .movementMain), at: tileCoord)
            gameHud?.showConfirmation(with: "Move to this location?")
            isConfirming = true
            desiredMoveTile = tileCoord
            break
        case .actionMove(let tileCoord):
            currentActiveUnit?.moveComponent.moveTo(tileCoord) {
                self.sceneState = .inactive
            }
            break
        case .readyAttack:
            gameBoard.activateTilesForAction(for: currentActiveUnit!)
            break
        case .confirmAttack(let tileCoord):
            break
        case .actionAttack(let tileCoord):
            // figure out attack size
            // figure out units effected
            // resolve event
            // switch state
            
            
            //highlightnodes are being removed too early
            var highlightTiles = [TileAndHighlightType]()
            for (key, values) in gameBoard.highlightLayer.getGroupedHighlightTiles {
                if key == tileCoord {
                    highlightTiles = values
                }
            }
            
            
            var arTar: [GameUnit] = []
            
            for unitEntity in unitEntities {
                if highlightTiles.contains(where: {$0.tileCoord == unitEntity.tileCoord}) {
                    arTar.append(unitEntity)
                }
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
    
    private func stateChangedToInactive() {
        gameHud?.updateUI()
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
    
    private func stateChangedToReadyMove() {
        gameBoard.activateTilesForMovement(for: currentActiveUnit!)
    }
    
}




