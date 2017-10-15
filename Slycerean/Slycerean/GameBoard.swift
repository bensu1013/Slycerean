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
    
    let collisionMap: CollisionMap
//    var unitActionMenu = UnitActionMenu()
    
    var size: CGSize {
        return CGSize(width: CGFloat(columns) * tileSize.width, height: CGFloat(rows) * tileSize.height)
    }
    
    var floorLayer: FloorLayerNode
    var doodadLayer: LayerNode
    var highlightLayer: HighlightLayerNode
    var unitLayer: UnitLayerNode
    var effectLayer: LayerNode
    
    init?(scene: GameScene, filename: String) {
        gameScene = scene
        
        
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
            0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,
            0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,
            0,0,0,0,1,0,0,0,0,0,0,0,0,0,0]
        
        collisionMap = CollisionMap(columns: 15, rows: 15, map: array)
        
        // purely graphical layer, shouldn't need collision checks
        floorLayer = FloorLayerNode(name: LayerType.floor.keyValue, tileData: temporaryTileMap["tiles"]! as! [[Int]], columns: 15, rows: 15, tileNames: [0:temporaryTileMap["type"]! as! String,2:kObjectNamedWall], tileSize: tileSize)
        floorLayer.zPosition = 0
        
        // graphical with potential object interaction checks ( traps? )
        doodadLayer = LayerNode(name: LayerType.doodad.keyValue)
        doodadLayer.zPosition = 100
        
        // selection colors blue / green / red ?
        highlightLayer = HighlightLayerNode(name: LayerType.highlight.keyValue)
        highlightLayer.zPosition = 200
        
        // actual unit entities on this layer
        unitLayer = UnitLayerNode(name: LayerType.unit.keyValue)
        unitLayer.zPosition = 300
        
        
        effectLayer = LayerNode(name: LayerType.effect.keyValue)
        effectLayer.zPosition = 400
        
        super.init()
        
        addChild(floorLayer)
        addChild(doodadLayer)
        addChild(highlightLayer)
        addChild(unitLayer)
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
            floorLayer.insertSprite(node: object, at: tileCoord)
        case .doodad:
            doodadLayer.insertSprite(node: object, at: tileCoord)
        case .highlight:
            highlightLayer.insertSprite(node: object, at: tileCoord)
        case .unit:
            unitLayer.insertSprite(node: object, at: tileCoord)
        case .effect:
            effectLayer.insertSprite(node: object, at: tileCoord)
        }
    }
    
    func layer(type: LayerType, removeObjectAt tileCoord: TileCoord) {
        switch type {
        case .floor:
            floorLayer.removeChildren(at: tileCoord)
        case .doodad:
            doodadLayer.removeChildren(at: tileCoord)
        case .highlight:
            highlightLayer.removeChildren(at: tileCoord)
        case .unit:
            unitLayer.removeChildren(at: tileCoord)
        case .effect:
            effectLayer.removeChildren(at: tileCoord)
        }
    }
    
    func getAllChildrenByLayersWith(tileCoord: TileCoord) -> [LayerType: [SKNode]] {
        var nodes = [LayerType:[SKNode]]()
        nodes[.doodad] = floorLayer.nodes(at: tileCoord)
        nodes[.highlight] = floorLayer.nodes(at: tileCoord)
        nodes[.unit] = floorLayer.nodes(at: tileCoord)
        return nodes
    }
    
    func removeAllChildrenInLayer(type: LayerType) {
        switch type {
        case .floor:
            floorLayer.removeAllChildren()
        case .doodad:
            doodadLayer.removeAllChildren()
        case .highlight:
            highlightLayer.removeAllChildren()
        case .unit:
            unitLayer.removeAllChildren()
        case .effect:
            effectLayer.removeAllChildren()
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
        let mainHighlightTile = HighlightSprite(type: .movementMain)
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
            !layer(type: .highlight, hasObjectNamed: HighlightType.movementStep.rawValue, at: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(type: .movementStep), at: tileCoord)
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
                        if unitLayer.hasNodeNamed("Unit", atCoord: top) && isValidAttackingTile(for: top) {
                            targetTiles.append(top)
                        }
                    }
                    
                    let bottom = startPos.bottom
                    if !checkedTiles.contains(bottom) {
                        checkedTiles.append(bottom)
                        nextTiles.append(bottom)
                        if unitLayer.hasNodeNamed("Unit", atCoord: bottom) && isValidAttackingTile(for: bottom) {
                            targetTiles.append(bottom)
                        }
                    }
                    let left = startPos.left
                    if !checkedTiles.contains(left) {
                        checkedTiles.append(left)
                        nextTiles.append(left)
                        if unitLayer.hasNodeNamed("Unit", atCoord: left) && isValidAttackingTile(for: left) {
                            targetTiles.append(left)
                        }
                    }
                    let right = startPos.right
                    if !checkedTiles.contains(right) {
                        checkedTiles.append(right)
                        nextTiles.append(right)
                        if unitLayer.hasNodeNamed("Unit", atCoord: right) && isValidAttackingTile(for: right) {
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
                if isValidHighlightTile(at: target) {
                    
                }
                break
            case .cross(let dist):
                var highlightTileAndType = [TileAndHighlightType]()
                highlightTileAndType.append((target, .targetMain))
                var top = target.top
                var bottom = target.bottom
                var left = target.left
                var right = target.right
                

                for _ in 1...dist {
                    
                    if isValidAttackingTile(for: top) {
                        highlightTileAndType.append((top, .targetSplash))
                    }
                    if isValidAttackingTile(for: bottom) {
                        highlightTileAndType.append((bottom, .targetSplash))
                    }
                    if isValidAttackingTile(for: left) {
                        highlightTileAndType.append((left, .targetSplash))
                    }
                    if isValidAttackingTile(for: right) {
                        highlightTileAndType.append((right, .targetSplash))
                    }
                    
                    top = top.top
                    bottom = bottom.bottom
                    left = left.left
                    right = right.right
                }
                highlightLayer.addHighlights(at: target, with: highlightTileAndType)
                break
            case .diamond( _):
                break
            case .square( _):
                break
            }
        }
        
    }
    
    private func isValidHighlightTile(at tileCoord: TileCoord) -> Bool {
        return self.isValidAttackingTile(for: tileCoord) && highlightLayer.hasNodeNamed("attack", atCoord: tileCoord)
    }
    
}

