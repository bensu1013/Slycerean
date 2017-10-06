//
//  TileBoard.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/9/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

let temporaryTileMap: [String:Any] =
[   "name"  : "Floor",
    "type"  : "medievalTile_",
    "tiles" : [
    [57, 58, 41, 50, 42, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [43, 50, 51, 42, 58, 42, 57, 41, 58, 51, 42, 57, 41, 51, 43],
    [41, 43, 42, 51, 51, 58, 57, 50, 42, 51, 42, 41, 43, 57, 50],
    [57, 58, 41, 50, 42, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [43, 50, 51, 42, 58, 42, 57, 41, 58, 51, 42, 57, 41, 51, 43],
    [57, 58, 41, 50, 42, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [41, 43, 42, 51, 51, 58, 57, 50, 42, 51, 42, 41, 43, 57, 50],
    [57, 58, 41, 50, 43, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [41, 50, 51, 42, 42, 58, 57, 57, 58, 51, 50, 42, 50, 51, 58],
    [57, 58, 41, 50, 42, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [41, 43, 42, 51, 51, 58, 57, 50, 42, 51, 42, 41, 43, 57, 50],
    [57, 58, 41, 50, 42, 41, 51, 58, 57, 57, 41, 43, 42, 51, 51],
    [41, 50, 51, 42, 41, 58, 57, 57, 58, 51, 50, 42, 50, 51, 58],
    [43, 50, 51, 42, 58, 42, 57, 41, 58, 51, 42, 57, 41, 51, 43],
    [41, 43, 42, 51, 51, 58, 57, 50, 42, 51, 42, 41, 43, 57, 50]]
]

enum LayerType {
    case floor, doodad, highlight, unit, effect
}

class GameBoard: SKNode {
    
    weak var gameScene: GameScene!
    
    /// Width of tilemap
    private var columns = 15
    /// Height of tilemap
    private var rows = 15
    /// Size of each tile
    private var tileSize = CGSize(width: 128, height: 128)
    
    var collisionMap: CollisionMap!
//    var unitActionMenu = UnitActionMenu()
    
    var size: CGSize {
        return CGSize(width: CGFloat(columns) * tileSize.width, height: CGFloat(rows) * tileSize.height)
    }
    
    var floorLayer: FloorLayerNode!
    var doodadLayer: LayerNode!
    var highlightLayer: HighlightLayerNode!
    var unitLayer: LayerNode!
    var effectLayer: LayerNode!
    
    init?(scene: GameScene, filename: String) {
        self.gameScene = scene
        super.init()
        
        // logic layer for collisions
        let array = [
            0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,
            0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,
            0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,
            0,0,0,0,1,0,0,0,0,0,0,0,0,0,0]
        
        self.collisionMap = CollisionMap(columns: 15, rows: 15, map: array)
        
        // purely graphical layer, shouldn't need collision checks
        floorLayer = FloorLayerNode(name: temporaryTileMap["name"]! as! String, tileData: temporaryTileMap["tiles"]! as! [[Int]], columns: 15, rows: 15, tileNames: [0:temporaryTileMap["type"]! as! String,2:kObjectNamedWall], tileSize: tileSize)
        floorLayer.zPosition = 0
        addChild(floorLayer)
        
        // graphical with potential object interaction checks ( traps? )
        doodadLayer = LayerNode(name: kLayerNamedDoodad)
        doodadLayer.zPosition = 100
        addChild(doodadLayer)
        
        // selection colors blue / green / red ?
        highlightLayer = HighlightLayerNode(name: kLayerNamedHighlight)
        highlightLayer.zPosition = 200
        addChild(highlightLayer)
        
        // actual unit entities on this layer
        unitLayer = LayerNode(name: kLayerNamedUnit)
        unitLayer.zPosition = 300
        addChild(unitLayer)
        
        effectLayer = LayerNode(name: "effect")
        effectLayer.zPosition = 400
        addChild(effectLayer)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isValidWalkingTile(for coord: TileCoord) -> Bool {
        let isInBounds = (coord.col >= 0 && coord.col < columns) && (coord.row >= 0 && coord.row < rows)
        let isUnoccupied = !layer(type: .unit, hasObjectNamed: "Unit", at: coord)
        if isInBounds && isUnoccupied {
            return self.collisionMap[coord] == 0
        }
        return false
    }
    
    func isValidAttackingTile(for coord: TileCoord) -> Bool {
        let isInBounds = (coord.col >= 0 && coord.col < columns) && (coord.row >= 0 && coord.row < rows)
        if isInBounds {
            return self.collisionMap[coord] == 0
        }
        return false
    }
    
    func layer(type: LayerType, isUnoccupiedAt tileCoord: TileCoord) -> Bool {
        switch type {
        case .floor:
            return floorLayer.nodes(at: tileCoord).isEmpty
        case .doodad:
            return doodadLayer.nodes(at: tileCoord).isEmpty
        case .highlight:
            return highlightLayer.nodes(at: tileCoord).isEmpty
        case .unit:
            return unitLayer.nodes(at: tileCoord).isEmpty
        case .effect:
            return effectLayer.nodes(at: tileCoord).isEmpty
        }
    }
    
    func layer(type: LayerType, hasObjectNamed objectName: String, at tileCoord: TileCoord) -> Bool {
        switch type {
        case .floor:
            return floorLayer.hasNodeNamed(objectName, atCoord: tileCoord)
        case .doodad:
            return doodadLayer.hasNodeNamed(objectName, atCoord: tileCoord)
        case .highlight:
            return highlightLayer.hasNodeNamed(objectName, atCoord: tileCoord)
        case .unit:
            return unitLayer.hasNodeNamed(objectName, atCoord: tileCoord)
        case .effect:
            return effectLayer.hasNodeNamed(objectName, atCoord: tileCoord)
        }
    }
    
    func layer(type: LayerType, insert object: SKNode, at tileCoord: TileCoord) {
        switch type {
        case .floor:
            return floorLayer.insertSprite(node: object, at: tileCoord)
        case .doodad:
            return doodadLayer.insertSprite(node: object, at: tileCoord)
        case .highlight:
            return highlightLayer.insertSprite(node: object, at: tileCoord)
        case .unit:
            return unitLayer.insertSprite(node: object, at: tileCoord)
        case .effect:
            return effectLayer.insertSprite(node: object, at: tileCoord)
        }
    }
    
    func layer(type: LayerType, removeObjectAt tileCoord: TileCoord) {
        switch type {
        case .floor:
            return floorLayer.removeChildren(at: tileCoord)
        case .doodad:
            return doodadLayer.removeChildren(at: tileCoord)
        case .highlight:
            return highlightLayer.removeChildren(at: tileCoord)
        case .unit:
            return unitLayer.removeChildren(at: tileCoord)
        case .effect:
            return effectLayer.removeChildren(at: tileCoord)
        }
    }
    
    func getAllChildrenInLayer(type: LayerType) -> [SKNode] {
        switch type {
        case .floor:
            return floorLayer.children
        case .doodad:
            return doodadLayer.children
        case .highlight:
            return highlightLayer.children
        case .unit:
            return unitLayer.children
        case .effect:
            return effectLayer.children
        }
    }
    
    func removeAllChildrenInLayer(type: LayerType) {
        switch type {
        case .floor:
            return floorLayer.removeAllChildren()
        case .doodad:
            return doodadLayer.removeAllChildren()
        case .highlight:
            return highlightLayer.removeAllChildren()
        case .unit:
            return unitLayer.removeAllChildren()
        case .effect:
            return effectLayer.removeAllChildren()
        }
    }
    
}

// Highlight Layer methods
extension GameBoard {
    
    func activateTilesForMovement(for unit: GameUnit) {
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        var startTiles = [unitPosition]
        var steps = 0
        // Bootleg way of changing button to have no action
        let mainHighlightTile = HighlightSprite(scene: gameScene, actionType: .attack)
        mainHighlightTile.buttonNode.removeFromParent()
        mainHighlightTile.buttonNode = nil
        mainHighlightTile.animateBlinking()
        layer(type: .highlight, insert: mainHighlightTile, at: unitPosition)
        
        while steps < unit.unusedMovementSteps {
            var nextTiles = [TileCoord]()
            for startPos in startTiles {
                let top = startPos.top
                if tryInsertWalkPathHighLight(at: top, for: unit) {
                    nextTiles.append(top)
                }
                let bottom = startPos.bottom
                if tryInsertWalkPathHighLight(at: bottom, for: unit) {
                    nextTiles.append(bottom)
                }
                let left = startPos.left
                if tryInsertWalkPathHighLight(at: left, for: unit) {
                    nextTiles.append(left)
                }
                let right = startPos.right
                if tryInsertWalkPathHighLight(at: right, for: unit) {
                    nextTiles.append(right)
                }
            }
            startTiles = nextTiles
            steps += 1
        }
    }
    
    func deactivateHighlightTiles() {
        removeAllChildrenInLayer(type: .highlight)
    }
    
    private func tryInsertWalkPathHighLight(at tileCoord: TileCoord, for unit: GameUnit) -> Bool {
        if self.isValidWalkingTile(for: tileCoord) &&
            !layer(type: .highlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(scene: gameScene, actionType: .move), at: tileCoord)
            return true
        }
        return false
    }
    
    func activateTilesForAction(for unit: GameUnit) {
//        guard let unitAction = unit.selectedAction else {
//            print("No action found when selection occured")
//            return
//        }
        
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        
        let top = unitPosition.top
        if tryInsertAttackPathHighlight(at: top, for: unit) {
            
        }
        let bottom = unitPosition.bottom
        if tryInsertAttackPathHighlight(at: bottom, for: unit) {
            
        }
        let left = unitPosition.left
        if tryInsertAttackPathHighlight(at: left, for: unit) {
            
        }
        let right = unitPosition.right
        if tryInsertAttackPathHighlight(at: right, for: unit) {
            
        }        
    }
    
    private func tryInsertAttackPathHighlight(at tileCoord: TileCoord, for unit: GameUnit) -> Bool {
        if self.isValidAttackingTile(for: tileCoord) &&
            !layer(type: .highlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(scene: gameScene, actionType: .attack), at: tileCoord)
            return true
        }
        return false
    }
    
}

