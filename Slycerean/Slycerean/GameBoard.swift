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

enum LayerType: String {
    case floor, doodad, highlight, unit, effect
    var keyValue: String {
        get {
            return "\(self)Layer"
        }
    }
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
    
    var layers = [LayerType : LayerNode]()
    
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
        let floorLayer = FloorLayerNode(name: LayerType.floor.keyValue, tileData: temporaryTileMap["tiles"]! as! [[Int]], columns: 15, rows: 15, tileNames: [0:temporaryTileMap["type"]! as! String,2:kObjectNamedWall], tileSize: tileSize)
        floorLayer.zPosition = 0
        layers[.floor] = floorLayer
        addChild(floorLayer)
        
        // graphical with potential object interaction checks ( traps? )
        let doodadLayer = LayerNode(name: LayerType.doodad.keyValue)
        doodadLayer.zPosition = 100
        layers[.doodad] = doodadLayer
        addChild(doodadLayer)
        
        // selection colors blue / green / red ?
        let highlightLayer = HighlightLayerNode(name: LayerType.highlight.keyValue)
        highlightLayer.zPosition = 200
        layers[.highlight] = highlightLayer
        addChild(highlightLayer)
        
        // actual unit entities on this layer
        let unitLayer = LayerNode(name: LayerType.unit.keyValue)
        unitLayer.zPosition = 300
        layers[.unit] = unitLayer
        addChild(unitLayer)
        
        let effectLayer = LayerNode(name: LayerType.effect.keyValue)
        effectLayer.zPosition = 400
        layers[.effect] = effectLayer
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
        if let layer = layers[type] {
            return layer.nodes(at: tileCoord).isEmpty
        }
        return true
    }
    
    func layer(type: LayerType, hasObjectNamed objectName: String, at tileCoord: TileCoord) -> Bool {
        if let layer = layers[type] {
            return layer.hasNodeNamed(objectName, atCoord: tileCoord)
        }
        return false
    }
    
    func layer(type: LayerType, insert object: SKNode, at tileCoord: TileCoord) {
        if let layer = layers[type] {
            layer.insertSprite(node: object, at: tileCoord)
        }
    }
    
    func layer(type: LayerType, removeObjectAt tileCoord: TileCoord) {
        if let layer = layers[type] {
            layer.removeChildren(at: tileCoord)
        }
    }
    
    func getAllChildrenByLayersWith(tileCoord: TileCoord) -> [LayerType: [SKNode]] {
        var nodes = [LayerType:[SKNode]]()
        for (type, layer) in layers {
            nodes[type] = layer.nodes(at: tileCoord)
        }
        return nodes
    }
    
    func getChildrenInLayer(type: LayerType, at tileCoord: TileCoord) -> [SKNode] {
        if let layer = layers[type] {
            return layer.nodes(at: tileCoord)
        }
        return [SKNode]()
    }
    
    func getAllChildrenInLayer(type: LayerType) -> [SKNode] {
        if let layer = layers[type] {
            return layer.children
        }
        return []
    }
    
    func removeAllChildrenInLayer(type: LayerType) {
        if let layer = layers[type] {
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
        let mainHighlightTile = HighlightSprite(scene: gameScene, actionType: .attack)
        mainHighlightTile.animateBlinking()
        layer(type: .highlight, insert: mainHighlightTile, at: unitPosition)
        
        while steps < unit.unusedMovementSteps {
            var nextTiles = [TileCoord]()
            for startPos in startTiles {
                let top = startPos.top
                if tryInsertWalkPathHighLight(at: top) {
                    nextTiles.append(top)
                }
                let bottom = startPos.bottom
                if tryInsertWalkPathHighLight(at: bottom) {
                    nextTiles.append(bottom)
                }
                let left = startPos.left
                if tryInsertWalkPathHighLight(at: left) {
                    nextTiles.append(left)
                }
                let right = startPos.right
                if tryInsertWalkPathHighLight(at: right) {
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
    
    private func tryInsertWalkPathHighLight(at tileCoord: TileCoord) -> Bool {
        if self.isValidWalkingTile(for: tileCoord) &&
            !layer(type: .highlight, hasObjectNamed: "move", at: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(scene: gameScene, actionType: .move), at: tileCoord)
            return true
        }
        return false
    }
    
    func activateTilesForAction(for unit: GameUnit) {
        guard let unitAction = unit.chosenSkill else {
            print("No skill found when selection occured")
            return
        }
        
        let unitPosition = TPConvert.tileCoordForPosition(unit.spriteComponent.position)
        let pattern = unitAction.attackPattern
        let distance = pattern.distance
        
        var steps = 0
        var targetTiles = [TileCoord]()
        if distance > 0 {
            var checkedTiles = [unitPosition]
            var startTiles  = [unitPosition]
            while steps < distance {
                var nextTiles = [TileCoord]()
                for startPos in startTiles {
                    let top = startPos.top
                    if !checkedTiles.contains(top) {
                        checkedTiles.append(top)
                        nextTiles.append(top)
                        if layer(type: .unit, hasObjectNamed: "Unit", at: top) && isValidAttackingTile(for: top) {
                            targetTiles.append(top)
                        }
                    }
                    
                    let bottom = startPos.bottom
                    if !checkedTiles.contains(bottom) {
                        checkedTiles.append(bottom)
                        nextTiles.append(bottom)
                        if layer(type: .unit, hasObjectNamed: "Unit", at: bottom) && isValidAttackingTile(for: bottom) {
                            targetTiles.append(bottom)
                        }
                    }
                    let left = startPos.left
                    if !checkedTiles.contains(left) {
                        checkedTiles.append(left)
                        nextTiles.append(left)
                        if layer(type: .unit, hasObjectNamed: "Unit", at: left) && isValidAttackingTile(for: left) {
                            targetTiles.append(left)
                        }
                    }
                    let right = startPos.right
                    if !checkedTiles.contains(right) {
                        checkedTiles.append(right)
                        nextTiles.append(right)
                        if layer(type: .unit, hasObjectNamed: "Unit", at: right) && isValidAttackingTile(for: right) {
                            targetTiles.append(right)
                        }
                    }
                }
                startTiles = nextTiles
                steps += 1
            }
        } else {
            targetTiles.append(unitPosition)
        }
        
        
        for target in targetTiles {
            switch pattern.pattern {
            case .point:
                if tryInsertAttackPathHighlight(at: target) {
                    
                }
                break
            case .cross(let dist):
                if tryInsertAttackPathHighlight(at: target) {
                    
                }
                for _ in 1...dist {
                    if tryInsertAttackPathHighlight(at: target.top) {
                        
                    }
                    if tryInsertAttackPathHighlight(at: target.bottom) {
                        
                    }
                    if tryInsertAttackPathHighlight(at: target.left) {
                        
                    }
                    if tryInsertAttackPathHighlight(at: target.right) {
                        
                    }
                }
                break
            case .diamond(let dist):
                break
            case .square(let dist):
                break
            }
        }
        
    }
    
    private func tryInsertAttackPathHighlight(at tileCoord: TileCoord) -> Bool {
        if self.isValidAttackingTile(for: tileCoord) &&
            !layer(type: .highlight, hasObjectNamed: "attack", at: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(scene: gameScene, actionType: .attack), at: tileCoord)
            return true
        }
        return false
    }
    
}

