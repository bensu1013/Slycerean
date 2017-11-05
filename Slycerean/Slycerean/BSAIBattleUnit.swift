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

    
    
    func takeTurn(inScene scene: GameScene, completion: @escaping () -> ()) {
        
        let enemyTeam = scene.battleController.userTeam
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = self
        
        var paths = [[TileCoord]]()
        
        for unit in enemyTeam.party {
            //cant land on unit
            if let path = pathFinder.shortestPathFromTileCoord(self.tileCoord, toTileCoord: unit.tileCoord) {
                var path = path
                path.removeLast()
                paths.append(path)
            }
        }
        
        if paths.isEmpty {
            
        } else {
            scene.sceneState = .actionMove(paths[0].last!)
        }
        

        
        completion()
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


