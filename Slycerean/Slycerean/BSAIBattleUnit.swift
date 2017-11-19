//
//  BSAIBattleUnit.swift
//  Slycerean
//
//  Created by Benjamin Su on 11/2/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSAIBattleUnit: BSBattleUnit, PathfinderDataSource {

    var actionStack = [()->()]()
    
    func takeTurn(inScene scene: BSBattleScene, completion: @escaping () -> ()) {
        self.scene = scene
        actionStack.append(completion)
        
        let enemyTeam = scene.battleController.userTeam
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = self
        
        var paths = [[TileCoord]]()
        
        for unit in enemyTeam.party {
            //cant land on unit
            var tempPaths = [[TileCoord]]()
            if let topPath = pathFinder.shortestPathFromTileCoord(self.tileCoord, toTileCoord: unit.tileCoord.top) {
                let path = topPath
                tempPaths.append(path)
            }
            if let bottomPath = pathFinder.shortestPathFromTileCoord(self.tileCoord, toTileCoord: unit.tileCoord.bottom) {
                let path = bottomPath
                tempPaths.append(path)
            }
            if let leftPath = pathFinder.shortestPathFromTileCoord(self.tileCoord, toTileCoord: unit.tileCoord.left) {
                let path = leftPath
                tempPaths.append(path)
            }
            if let rightPath = pathFinder.shortestPathFromTileCoord(self.tileCoord, toTileCoord: unit.tileCoord.right) {
                let path = rightPath
                tempPaths.append(path)
            }
            let shortestPath = tempPaths.sorted(by: { $0.count < $1.count }).first
            if let shortestPath = shortestPath {
                paths.append(shortestPath)
            }
        }
        
        if paths.isEmpty {
            
        } else {
            paths.sort(by: { $0.count < $1.count })
            self.moveComponent.moveAlong(path: paths[0], completion: {
                self.spriteComponent.run(SKAction.wait(forDuration: 1.0))
                scene.sceneState = .turnEnd
            })
        }
        
        
       
        
    }
    
    func useActions() {
        let wait = SKAction.wait(forDuration: 4.0)
        let action = SKAction.run {
            let nextAction = self.actionStack.removeLast()
            nextAction()
        }
        let complete = SKAction.run { [weak self] in
            if !self!.actionStack.isEmpty {
                self?.useActions()
            }
        }
        
        self.spriteComponent.run(SKAction.sequence([action, wait, complete]))
    }
    
    func walkableAdjacentTilesCoordsForTileCoord(_ tileCoord: TileCoord) -> [TileCoord] {
        let canMoveUp = scene?.gameBoard.isValidWalkingTile(for: tileCoord.top) ?? false
        let canMoveLeft = scene?.gameBoard.isValidWalkingTile(for: tileCoord.left) ?? false
        let canMoveDown = scene?.gameBoard.isValidWalkingTile(for: tileCoord.bottom) ?? false
        let canMoveRight = scene?.gameBoard.isValidWalkingTile(for: tileCoord.right) ?? false
        
        var walkableCoords = [TileCoord]()
        
        if canMoveUp {
            walkableCoords.append(tileCoord.top)
        }
        if canMoveLeft {
            walkableCoords.append(tileCoord.left)
        }
        if canMoveDown {
            walkableCoords.append(tileCoord.bottom)
        }
        if canMoveRight {
            walkableCoords.append(tileCoord.right)
        }
        return walkableCoords
    }
    
    func costToMoveFromTileCoord(_ fromTileCoord: TileCoord, toAdjacentTileCoord toTileCoord: TileCoord) -> Int {
        return 5
    }
    
}


