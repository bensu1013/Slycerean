//
//  GameScene.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import SpriteKit
import GameplayKit


enum SceneState {
    case inactive, readyMove, confirmMove(TileCoord), actionMove(TileCoord), readyAttack, confirmAttack([TileCoord]), actionAttack([TileCoord]), turnEnd
}

class BSBattleScene: SKScene {
    
    var sceneState: SceneState = .inactive {
        didSet {
            shiftSceneTo(state: sceneState)
        }
    }
    
    var gameBoard: BSGameBoard!
    var gameCamera: BSBattleCamera!
    var battleController: BSBattleController!
    var tempTurnIndex = 0
    
    weak var gameHud: BSGameHUD?
    var currentActiveUnit: BSBattleUnit? {
        return battleController.currentActiveUnit
    }
    var isAITurn: Bool = false
    var userTurn: Bool = true {
        didSet {
            isUserInteractionEnabled = userTurn
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        gameBoard = BSGameBoard(scene: self, filename: "Level_0")
        addChild(gameBoard)
        
        let player = BSUserData.shared.party[0]
        let bUnit = BSBattleUnit(gameUnit: player, atCoord: TileCoord(col: 4, row: 4), inScene: self)
        bUnit.spriteComponent.isUserInteractionEnabled = false
        bUnit.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit.spriteComponent, at: bUnit.tileCoord)
        
        let player2 = BSGameUnit(stats: BSCharacterStats(name: "Thorn", health: 25, energy: 5, actionSpeed: 4, level: 1, job: .ranger), equipment: BSCharacterEquipment(weapon: "", armor: "", relic: ""))
        let bUnit2 = BSAIBattleUnit(gameUnit: player2, atCoord: TileCoord(col: 13, row: 13), inScene: self)
        bUnit2.spriteComponent.isUserInteractionEnabled = false
        bUnit2.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit2.spriteComponent, at: bUnit2.tileCoord)
        
        let player3 = BSGameUnit(stats: BSCharacterStats(name: "Steal", health: 24, energy: 4, actionSpeed: 4, level: 1, job: .rogue), equipment: BSCharacterEquipment(weapon: "", armor: "", relic: ""))
        let bUnit3 = BSAIBattleUnit(gameUnit: player3, atCoord: TileCoord(col: 14, row: 14), inScene: self)
        bUnit3.spriteComponent.isUserInteractionEnabled = false
        bUnit3.spriteComponent.anchorPoint = CGPoint.zero
        gameBoard.layer(type: .unit, insert: bUnit3.spriteComponent, at: bUnit3.tileCoord)
        
        battleController = BSBattleController(userTeam: BSBattleTeam.init(team: .user, party: [bUnit]),
                                              aiTeam: BSBattleTeam.init(team: .ai, party: [bUnit2, bUnit3]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {

    }
    
    func setupCamera(_ gameCamera: BSBattleCamera) {
        self.gameCamera = gameCamera
        self.addChild(gameCamera)
        self.camera = gameCamera
    }
    
    func nextUnitTurn() {
        battleController.findNextActiveUnit()
        prepareSceneFor(unit: battleController.currentActiveUnit!)
    }
    
    private func prepareSceneFor(unit: BSBattleUnit) {
        unit.prepareTurn()
        gameHud?.setSelectedUnitHud(with: unit)
        gameHud?.setGameScene(self)
        gameCamera.move(to: unit.spriteComponent.position, animated: true)
        if unit.team == .user {
            self.isAITurn = false
            self.sceneState = .inactive
        } else {
            self.isAITurn = true
            guard let unit = unit as? BSAIBattleUnit else {
                self.sceneState = .turnEnd
                return
            }
            unit.takeTurn(inScene: self, completion: {
                self.sceneState = .turnEnd
            })
        }
    }
    
}

extension BSBattleScene: ActionHUDButtonDelegate {
    func firstSkillAction() {
        guard let unit = currentActiveUnit else { return }
        if !unit.hasActed {
            unit.selectedSkill = unit.equippedSkills[0]
            sceneState = .readyAttack
        }
    }
    
    func secondSkillAction() {
        guard let unit = currentActiveUnit else { return }
        if !unit.hasActed {
            unit.selectedSkill = unit.equippedSkills[1]
            sceneState = .readyAttack
        }
    }
    
    func thirdSkillAction() {
        guard let unit = currentActiveUnit else { return }
        if !unit.hasActed {
            unit.selectedSkill = unit.equippedSkills[2]
            sceneState = .readyAttack
        }
    }
    
    func fourthSkillAction() {
        guard let unit = currentActiveUnit else { return }
        if !unit.hasActed {
            unit.selectedSkill = unit.equippedSkills[3]
            sceneState = .readyAttack
        }
    }
    
    func basicSkillAction() {
        if let unit = currentActiveUnit {
            if !unit.hasActed {
                unit.selectedBasicAttack()
                sceneState = .readyAttack
            }
        }
    }
    
    func skillsForUnit() -> [BSActivatableSkill] {
        return currentActiveUnit?.equippedSkills ?? []
    }
    
    func movementAction() {
        sceneState = .readyMove
    }
    
    func endTurnAction() {
        sceneState = .turnEnd
    }
}

//MARK: - Tap Management
extension BSBattleScene {
    // taprecognizer of view sent to scene to process
    func tapped(at point: CGPoint) {
        guard let gameHud = gameHud else { return }
        
        if isAITurn { return }
        
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
            for unit in battleController.allUnits {
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
extension BSBattleScene {
    
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
//        case .aiControl:
//            stateChangedToAIControl()
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
        let pathfinder = AStarPathfinder()
        pathfinder.dataSource = currentActiveUnit?.moveComponent
        let path = pathfinder.shortestPathFromTileCoord(currentActiveUnit!.tileCoord, toTileCoord: tileCoord)
        currentActiveUnit?.moveComponent.moveAlong(path: path!) {
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
        for unitEntity in battleController.allUnits {
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
        battleController.currentActiveUnit = nil
        gameHud?.confirmationComponent.hideAlert()
        self.sceneState = .inactive
    }
    
//    private func stateChangedToAIControl() {
//        if let unit = currentActiveUnit as? BSAIBattleUnit {
//            unit.takeTurn(board: gameBoard) {
//                self.sceneState = .turnEnd
//            }
//        }
//    }
    
}
