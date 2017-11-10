//
//  BSTilePlotter.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/21/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

struct BSTilePlotter {
    
    static func getValidWalkingTiles(onGameBoard board: GameBoard, forUnit unit: BSBattleUnit) -> [TileCoord] {
        
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        var moveTiles = Set<TileCoord>()
        var startTiles = [unitPosition]
        var steps = 0
        while steps < unit.maxMovement {
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
    
    static func getValidAttackingTiles(onGameBoard board: GameBoard, forUnit unit: BSBattleUnit) -> [TileCoord] {
        guard let action = unit.selectedSkill else {
            print("No skill found when selection occured")
            return []
        }
        
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        var attackTiles = Set<TileCoord>()
        var checkedTiles = Set<TileCoord>()
        var startTiles = [unitPosition]
        var steps = 0
        
        while steps < action.attackPattern.max {
            var nextTiles = [TileCoord]()
            for startPos in startTiles {
                let top = startPos.top
                if board.isValidAttackingTile(for: top) &&
                    !checkedTiles.contains(top) {
                    if steps >= action.attackPattern.min {
                        attackTiles.insert(top)
                    }
                    checkedTiles.insert(top)
                    nextTiles.append(top)
                }
                let bottom = startPos.bottom
                if board.isValidAttackingTile(for: bottom) &&
                    !checkedTiles.contains(bottom) {
                    if steps >= action.attackPattern.min {
                        attackTiles.insert(bottom)
                    }
                    checkedTiles.insert(bottom)
                    nextTiles.append(bottom)
                }
                let left = startPos.left
                if board.isValidAttackingTile(for: left) &&
                    !checkedTiles.contains(left) {
                    if steps >= action.attackPattern.min {
                        attackTiles.insert(left)
                    }
                    checkedTiles.insert(left)
                    nextTiles.append(left)
                }
                let right = startPos.right
                if board.isValidAttackingTile(for: right) &&
                    !checkedTiles.contains(right) {
                    if steps >= action.attackPattern.min {
                        attackTiles.insert(right)
                    }
                    checkedTiles.insert(right)
                    nextTiles.append(right)
                }
            }
            startTiles = nextTiles
            steps += 1
        }
        return Array(attackTiles)
    }
    
    static func getValidCrossPatternTiles(onGameBoard board: GameBoard,
                                   withRange range: Int,
                                   atTileCoord tileCoord: TileCoord) -> [TileCoord] {
        var patternTiles = [tileCoord]
        var top = tileCoord.top
        var bottom = tileCoord.bottom
        var left = tileCoord.left
        var right = tileCoord.right
        for _ in 1...range {
            if board.isValidAttackingTile(for: top) {
                patternTiles.append(top)
            }
            if board.isValidAttackingTile(for: bottom) {
                patternTiles.append(bottom)
            }
            if board.isValidAttackingTile(for: left) {
                patternTiles.append(left)
            }
            if board.isValidAttackingTile(for: right) {
                patternTiles.append(right)
            }
            
            top = top.top
            bottom = bottom.bottom
            left = left.left
            right = right.right
        }
        return patternTiles
    }
    
    static func getValidDiamondPatternTiles(onGameBoard board: GameBoard,
                                          withRange range: Int,
                                          atTileCoord tileCoord: TileCoord) -> [TileCoord] {
        var patternTiles = [tileCoord]
        var top = tileCoord.top
        var bottom = tileCoord.bottom
        var left = tileCoord.left
        var right = tileCoord.right
        for _ in 1...range {
            if board.isValidAttackingTile(for: top) {
                patternTiles.append(top)
            }
            if board.isValidAttackingTile(for: bottom) {
                patternTiles.append(bottom)
            }
            if board.isValidAttackingTile(for: left) {
                patternTiles.append(left)
            }
            if board.isValidAttackingTile(for: right) {
                patternTiles.append(right)
            }
            
            top = top.top
            bottom = bottom.bottom
            left = left.left
            right = right.right
        }
        return patternTiles
    }
    
    static func getValidSquarePatternTiles(onGameBoard board: GameBoard,
                                          withRange range: Int,
                                          atTileCoord tileCoord: TileCoord) -> [TileCoord] {
        var startCoord = tileCoord
        for _ in 1...range {
            startCoord = startCoord.topLeft
        }
        var startCoords = [startCoord]
        for _ in 1...(range * 2) {
            startCoord = startCoord.right
            startCoords.append(startCoord)
        }
        var patternTiles = startCoords
        for sCoord in startCoords {
            var nextCoord = sCoord.bottom
            for _ in 1...(range * 2) {
                if board.isValidAttackingTile(for: nextCoord) {
                    patternTiles.append(nextCoord)
                }
                nextCoord = nextCoord.bottom
            }
        }
        return patternTiles
    }
}
