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
    var unitEntities = [BSBattleUnit]()
    var units = [GameUnit]()
    var tempTurnIndex = 0
    
    weak var gameHud: BSGameHUD?
    var currentActiveUnit: BSBattleUnit?
    
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
        
        let player = GameUnit(job: .warrior, level: 2)
        units.append(player)
        let bUnit = BSBattleUnit(gameUnit: player, atCoord: TileCoord(col: 4, row: 4), inScene: self)
        bUnit.spriteComponent.isUserInteractionEnabled = false
        bUnit.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit.spriteComponent, at: bUnit.tileCoord)
        unitEntities.append(bUnit)
        
        let player1 = GameUnit(job: .wizard, level: 10)
        units.append(player1)
        let bUnit1 = BSBattleUnit(gameUnit: player1, atCoord: TileCoord(col: 4, row: 3), inScene: self)
        bUnit1.spriteComponent.isUserInteractionEnabled = false
        bUnit1.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit1.spriteComponent, at: bUnit1.tileCoord)
        unitEntities.append(bUnit1)
        
        let player2 = GameUnit(job: .ranger, level: 5)
        units.append(player2)
        let bUnit2 = BSBattleUnit(gameUnit: player2, atCoord: TileCoord(col: 7, row: 6), inScene: self)
        bUnit2.spriteComponent.isUserInteractionEnabled = false
        bUnit2.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit2.spriteComponent, at: bUnit2.tileCoord)
        unitEntities.append(bUnit2)
        
        let player3 = GameUnit(job: .rogue, level: 5)
        units.append(player3)
        let bUnit3 = BSBattleUnit(gameUnit: player3, atCoord: TileCoord(col: 5, row: 6), inScene: self)
        bUnit3.spriteComponent.isUserInteractionEnabled = false
        bUnit3.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit3.spriteComponent, at: bUnit3.tileCoord)
        unitEntities.append(bUnit3)
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
    
    private func prepareSceneFor(unit: BSBattleUnit) {
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
        case .confirmMove(let moveTile):
            tappedWhenConfirmMove(atPoint: point, withMoveTile: moveTile)
        case .readyAttack:
            tappedWhenReadyAttack(atPoint: point)
        case .confirmAttack(let attackTiles):
            tappedWhenConfirmAttack(atPoint: point, withAttackTiles: attackTiles)
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
            let attackTiles = gameBoard.getAttackPatternTiles(attackPattern: currentActiveUnit!.selectedSkill!.attackPattern, atTileCoord: tileCoord)
            var hasTarget = false
            for unit in unitEntities {
                if attackTiles.contains(unit.tileCoord) {
                    if let curUnit = currentActiveUnit,
                         let skill = curUnit.selectedSkill {
                        if !(skill.skillType == .basic &&
                            unit === curUnit) {
                            hasTarget = true
                        }
                    }
                    
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
        if gameBoard.tryPlacingMovementTiles(for: currentActiveUnit!) {
            
        }
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
        if gameBoard.tryPlacingAttackTiles(for: currentActiveUnit!) {
            
        }
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
        var arTar: [BSBattleUnit] = []
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
        gameHud?.confirmationComponent.hideAlert()
        self.sceneState = .inactive
    }
    
}
