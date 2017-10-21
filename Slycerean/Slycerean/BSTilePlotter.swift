//
//  BSTilePlotter.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/21/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

struct BSTilePlotter {
    
    static func getValidWalkingTiles(onGameBoard board: GameBoard, forUnit unit: GameUnit) -> [TileCoord] {
        
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        var moveTiles = Set<TileCoord>()
        var startTiles = [unitPosition]
        var steps = 0
        while steps < unit.unusedMovementSteps {
            var nextTiles = [TileCoord]()
            for startPos in startTiles {
                let top = startPos.top
                if board.isValidWalkingTile(for: top) &&
                    !moveTiles.contains(top) {
                    nextTiles.append(top)
                    moveTiles.insert(top)
                }
                let bottom = startPos.bottom
                if board.isValidWalkingTile(for: bottom) &&
                    !moveTiles.contains(bottom) {
                    nextTiles.append(bottom)
                    moveTiles.insert(bottom)
                }
                let left = startPos.left
                if board.isValidWalkingTile(for: left) &&
                    !moveTiles.contains(left) {
                    nextTiles.append(left)
                    moveTiles.insert(left)
                }
                let right = startPos.right
                if board.isValidWalkingTile(for: right) &&
                    !moveTiles.contains(right) {
                    nextTiles.append(right)
                    moveTiles.insert(right)
                }
            }
            startTiles = nextTiles
            steps += 1
        }
        return Array(moveTiles)
    }
    
    
}
