//
//  MoveComponent.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/3/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import GameplayKit

class MoveComponent {
    
    weak var scene: GameScene?
    weak var unit: GameUnit?
    var shortestPath: [TileCoord]?
    fileprivate var currentStepAction: SKAction?
    var pathfinder = AStarPathfinder()
    
    init(for  unit: GameUnit, in scene: GameScene) {
        self.scene = scene
        self.unit = unit
        self.pathfinder.dataSource = self
    }
    
    
    func moveTo(_ toTileCoord: TileCoord) {
        guard let unit = unit else { return }
        
        unit.hasMoved = true
        
        // Get the current and desired tile coordinates
        let fromTileCoord = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        
        // Check that we are actually moving somewhere
        if fromTileCoord == toTileCoord {
            return
        }
        // Must check that the desired location is walkable
        if !(scene?.gameBoard.isValidWalkingTile(for: toTileCoord) ?? true) {
            return
        }
        
        self.shortestPath = self.pathfinder.shortestPathFromTileCoord(fromTileCoord, toTileCoord: toTileCoord)
        if let _ = shortestPath {
            unit.tileCoord = toTileCoord
            self.popStepAndAnimate()
        }
    }
    
    func popStepAndAnimate() {
        currentStepAction = nil
        guard let unit = unit else { return }
        
        // check if we are done moving
        if shortestPath == nil || shortestPath!.isEmpty {
            // prep for next action
            unit.prepareTurn()
            unit.spriteComponent.removeAction(forKey: "walk")
            return
        }
        
        // get the next step to move to and remove it from the shortestPath
        let nextTileCoord = shortestPath!.remove(at: 0)
        
        // determine the direction the cat is facing in order to animate it appropriately
        let currentTileCoord = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        
        // make sure the cat is facing in the right direction for its movement
        let diff = nextTileCoord - currentTileCoord
        if abs(diff.col) > abs(diff.row) {
            if diff.col > 0 {
                unit.spriteComponent.walk(.right, withKey: "walk")
            } else {
                unit.spriteComponent.walk(.left, withKey: "walk")
            }
        } else {
            if diff.row > 0 {
                unit.spriteComponent.walk(.up, withKey: "walk")
            } else {
                unit.spriteComponent.walk(.down, withKey: "walk")
            }
        }
        
        currentStepAction = SKAction.move(to: TPConvert.positionForTileCoord(nextTileCoord), duration: 0.4)
        unit.spriteComponent.run(currentStepAction!, completion: {
            self.popStepAndAnimate()
        })
    }
}

extension MoveComponent: PathfinderDataSource {
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
        let baseCost = (fromTileCoord.col != toTileCoord.col) && (fromTileCoord.row != toTileCoord.row) ? 14 : 10
        return baseCost
    }
}
