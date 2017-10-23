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
    case inactive, readyMove, confirmMove(TileCoord), actionMove(TileCoord), readyAttack, confirmAttack([TileCoord]), actionAttack([TileCoord]), turnEnd
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
    
    var userTurn: Bool = true {
        didSet {
            isUserInteractionEnabled = userTurn
        }
    }
    
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
        player.tileCoord = TileCoord(col: 4, row: 4)
        player.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player.spriteComponent, at: player.tileCoord)
        unitEntities.append(player)
        
        let player1 = GameUnit(scene: self)
        player1.spriteComponent.isUserInteractionEnabled = false
        player1.tileCoord = TileCoord(col: 4, row: 3)
        player1.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player1.spriteComponent, at: player1.tileCoord)
        unitEntities.append(player1)
        
        let player2 = GameUnit(scene: self)
        player2.spriteComponent.isUserInteractionEnabled = false
        player2.tileCoord = TileCoord(col: 7, row: 6)
        player2.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: player2.spriteComponent, at: player2.tileCoord)
        unitEntities.append(player2)
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
    
    private func prepareSceneFor(unit: GameUnit) {
        currentActiveUnit = unit
        unit.prepareTurn()
        gameHud?.setSelectedUnitHud(with: unit)
        gameHud?.setGameScene(self)
        gameCamera.move(to: unit.spriteComponent.position, animated: true)
        self.sceneState = .inactive
    }
    
}

//MARK: - Tap Management
extension GameScene {
    // taprecognizer of view sent to scene to process
    func tapped(at point: CGPoint) {
        guard let gameHud = gameHud else { return }
        let cameraPoint = self.convert(point, to: gameHud.actionMenuComponent)
        if gameHud.tryActionWithTap(on: cameraPoint) {
            return
        }
        switch sceneState {
        case .readyMove:
            tappedWhenReadyMove(atPoint: point)
            break
        case .confirmMove(let moveTile):
            tappedWhenConfirmMove(atPoint: point, withMoveTile: moveTile)
            break
        case .readyAttack:
            tappedWhenReadyAttack(atPoint: point)
            break
        case .confirmAttack(let attackTiles):
            tappedWhenConfirmAttack(atPoint: point, withAttackTiles: attackTiles)
            break
        default:
            break
        }
    }
    
    private func tappedWhenReadyMove(atPoint point: CGPoint) {
        let tileCoord = TPConvert.tileCoordForPosition(point)
        if gameBoard.layer(type: .highlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            sceneState = .confirmMove(tileCoord)
        }
    }
    
    private func tappedWhenConfirmMove(atPoint point: CGPoint, withMoveTile tileCoord: TileCoord) {
        guard let gameHud = gameHud else { return }
        let confirmPoint = self.convert(point, to: gameHud.confirmationComponent)
        guard let tapped = gameHud.tryConfirmWithTap(on: confirmPoint) else { return }
        if tapped {
            sceneState = .actionMove(tileCoord)
        } else {
            sceneState = .readyMove
        }
    }
    
    private func tappedWhenReadyAttack(atPoint point: CGPoint) {
        let tileCoord = TPConvert.tileCoordForPosition(point)
        if gameBoard.layer(type: .highlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            // find all tiles affected by skill and if unit can be targeted
            let attackTiles = gameBoard.getAttackPatternTiles(attackPattern: currentActiveUnit!.chosenSkill!.attackPattern, atTileCoord: tileCoord)
            var hasTarget = false
            for unit in unitEntities {
                if attackTiles.contains(unit.tileCoord) {
                    hasTarget = true
                }
            }
            if hasTarget {
                self.sceneState = .confirmAttack(attackTiles)
            } else {
                print("no targets found in skill area")
            }
        }
    }
    
    private func tappedWhenConfirmAttack(atPoint point: CGPoint,withAttackTiles attackTiles: [TileCoord]) {
        guard let gameHud = gameHud else { return }
        let confirmPoint = self.convert(point, to: gameHud.confirmationComponent)
        guard let tapped = gameHud.tryConfirmWithTap(on: confirmPoint) else { return }
        if tapped {
            sceneState = .actionAttack(attackTiles)
        } else {
            sceneState = .readyAttack
        }
    }
    
}

//MARK: - SceneState Management
extension GameScene {
    
    func shiftSceneTo(state: SceneState) {
        gameBoard.deactivateHighlightTiles()
        switch state {
        case .inactive:
            stateChangedToInactive()
        case .readyMove:
            stateChangedToReadyMove()
        case .confirmMove(let tileCoord):
            stateChangedToConfirmMove(tileCoord: tileCoord)
        case .actionMove(let tileCoord):
            stateChangedToActionMove(tileCoord: tileCoord)
        case .readyAttack:
            stateChangedToReadyAttack()
        case .confirmAttack(let attackTiles):
            stateChangedToConfirmAttack(tileCoords: attackTiles)
        case .actionAttack(let attackTiles):
            stateChangedToActionAttack(tileCoords: attackTiles)
        case .turnEnd:
            stateChangedtoTurnEnd()
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
        gameBoard.tryPlacingMovementTiles(for: currentActiveUnit!)
    }
    
    private func stateChangedToConfirmMove(tileCoord: TileCoord) {
        gameBoard.removeAllChildrenInLayer(type: .highlight)
        gameBoard.layer(type: .highlight, insert: HighlightSprite.init(type: .movementMain), at: tileCoord)
        gameHud?.showConfirmation(with: "Move to this location?")
    }
    
    private func stateChangedToActionMove(tileCoord: TileCoord) {
        currentActiveUnit?.moveComponent.moveTo(tileCoord) {
            self.sceneState = .inactive
        }
    }
    
    private func stateChangedToReadyAttack() {
        gameBoard.tryPlacingAttackTiles(for: currentActiveUnit!)
    }
    
    private func stateChangedToConfirmAttack(tileCoords: [TileCoord]) {
        gameBoard.removeAllChildrenInLayer(type: .highlight)
        if !gameBoard.tryPlacingAttackPatternTiles(withTiles: tileCoords) {
            sceneState = .readyAttack
            return
        }
        gameHud?.showConfirmation(with: "Attack here?")
    }
    
    private func stateChangedToActionAttack(tileCoords: [TileCoord]) {
        var arTar: [GameUnit] = []
        for unitEntity in unitEntities {
            if tileCoords.contains(where: {$0 == unitEntity.tileCoord}) {
                arTar.append(unitEntity)
            }
        }
        currentActiveUnit?.attackEventAndDamage(units: arTar) {
            self.sceneState = .inactive
        }
    }
    
    private func stateChangedtoTurnEnd() {
        currentActiveUnit?.endTurn()
        currentActiveUnit = nil
        self.sceneState = .inactive
    }
    
}
