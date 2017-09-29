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


class GameBoard: SKNode {
    
    /// Width of tilemap
    private var columns = 15
    /// Height of tilemap
    private var rows = 15
    /// Size of each tile
    private var tileSize = CGSize(width: 128, height: 128)
    
    var collisionMap: CollisionMap!
    var unitActionMenu = UnitActionMenu()
    
    var size: CGSize {
        return CGSize(width: CGFloat(columns) * tileSize.width, height: CGFloat(rows) * tileSize.height)
    }
    
    // each level will have several layers
 var layers = [String : LayerNode]()

    init?(filename: String) {
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
        let floorLayer = TiledLayerNode(name: temporaryTileMap["name"]! as! String, tileData: temporaryTileMap["tiles"]! as! [[Int]], columns: 15, rows: 15, tileNames: [0:temporaryTileMap["type"]! as! String,2:kObjectNamedWall], tileSize: tileSize)
        floorLayer.zPosition = 0
        layers[kLayerNamedFloor] = floorLayer
        self.addChild(floorLayer)
        
        // graphical with potential object interaction checks ( traps? )
        let doodadLayer = LayerNode(name: kLayerNamedDoodad)
        doodadLayer.zPosition = 100
        layers[kLayerNamedDoodad] = doodadLayer
        self.addChild(doodadLayer)
        
        // selection colors blue / green / red ?
        let highlightLayer = LayerNode(name: kLayerNamedHighlight)
        highlightLayer.zPosition = 200
        layers[kLayerNamedHighlight] = highlightLayer
        self.addChild(highlightLayer)
        
        // actual unit entities on this layer
        let unitLayer = LayerNode(name: kLayerNamedUnit)
        unitLayer.zPosition = 300
        layers[kLayerNamedUnit] = unitLayer
        self.addChild(unitLayer)
        
        //only one actionmenu active at a time
        self.addChild(unitActionMenu)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isValidWalkingTile(for coord: TileCoord) -> Bool {
        let isInBounds = (coord.col >= 0 && coord.col < columns) && (coord.row >= 0 && coord.row < rows)
        let isUnoccupied = !layerNamed(kLayerNamedUnit, hasObjectNamed: "Unit", at: coord)
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
    
    func layerNamed(_ name: String, isUnoccupiedAt tileCoord: TileCoord) -> Bool {
        if let layer = layers[name] {
            return layer.nodes(at: tileCoord).isEmpty
        }
        return true
    }
    
    func layerNamed(_ name: String, hasObjectNamed objectName: String, at tileCoord: TileCoord) -> Bool {
        if let layer = layers[name] {
            return layer.hasNodeNamed(objectName, atCoord: tileCoord)
        }
        return false
    }
    
    func layerNamed(_ name: String, insert object: SKNode, at tileCoord: TileCoord) {
        if let layer = layers[name] {
            layer.insertSprite(node: object, at: tileCoord)
        }
    }
    
    func layerNamed(_ name: String, removeObjectAt tileCoord: TileCoord) {
        if let layer = layers[name] {
            layer.removeChildren(at: tileCoord)
        }
    }
    
    func removeAllChildrenInLayerNamed(_ name: String) {
        if let layer = layers[name] {
            layer.removeAllChildren()
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
        let mainHighlightTile = HighlightSprite(unit: unit, actionType: .attack)
        mainHighlightTile.button?.removeFromParent()
        mainHighlightTile.button = nil
        mainHighlightTile.animateBlinking()
        layerNamed(kLayerNamedHighlight, insert: mainHighlightTile, at: unitPosition)
        
        while steps < unit.moveSpaces {
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
//        layerNamed(kLayerNamedHighlight, removeObjectAt: unitPosition)
    }
    
    func deactivateHighlightTiles() {
        removeAllChildrenInLayerNamed(kLayerNamedHighlight)
    }
    
    private func tryInsertWalkPathHighLight(at tileCoord: TileCoord, for unit: GameUnit) -> Bool {
        if self.isValidWalkingTile(for: tileCoord) &&
           !layerNamed(kLayerNamedHighlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            layerNamed(kLayerNamedHighlight, insert: HighlightSprite(unit: unit, actionType: .move), at: tileCoord)
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
            !layerNamed(kLayerNamedHighlight, hasObjectNamed: kObjectHighlightPath, at: tileCoord) {
            layerNamed(kLayerNamedHighlight, insert: HighlightSprite(unit: unit, actionType: .attack), at: tileCoord)
            return true
        }
        return false
    }
    
}

