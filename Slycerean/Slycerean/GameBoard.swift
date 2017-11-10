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
        
        if let dictionary = BSBundle.loadJSONFromBundle(filename) {
            // width and height in tiles for the level
            columns = dictionary["width"] as? Int ?? 0
            rows = dictionary["height"] as? Int ?? 0
            
            tileSize.width = dictionary["tileWidth"] as? CGFloat ?? 0
            tileSize.height = dictionary["tileHeight"] as? CGFloat ?? 0
            
            collisionMap = CollisionMap(columns: columns, rows: rows, map: dictionary["collisionMap"] as? [[Int]] ?? [[0]])
            
            floorLayer = FloorLayerNode(name: LayerType.floor.keyValue)
            floorLayer.zPosition = 0
            
            // purely graphical layer, shouldn't need collision checks
            if let layersArray = dictionary["layers"] as? [[String:Any]] {
                for (layerIndex, layerData) in layersArray.enumerated() {
                    floorLayer.loadSublayer(withData: layerData, atZPosition: layersArray.count - layerIndex)
                }
            }
        } else {
            return nil
        }
        
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
    
    func deactivateHighlightTiles() {
        removeAllChildrenInLayer(type: .highlight)
    }
    
    func tryPlacingMovementTiles(for unit: BSBattleUnit) -> Bool {
        if unit.hasMoved { return false }
        let moveTiles = BSTilePlotter.getValidWalkingTiles(onGameBoard: self, forUnit: unit)
        if moveTiles.isEmpty { return false }
        layer(type: .highlight, insert: HighlightSprite(type: .movementMain), at: unit.tileCoord)
        for tile in moveTiles {
            layer(type: .highlight, insert: HighlightSprite(type: .movementStep), at: tile)
        }
        return true
    }
    
    func tryPlacingAttackTiles(for unit: BSBattleUnit) -> Bool {
        let attackTiles = BSTilePlotter.getValidAttackingTiles(onGameBoard: self, forUnit: unit)
        if attackTiles.isEmpty { return false }
        layer(type: .highlight, insert: HighlightSprite(type: .movementMain), at: unit.tileCoord)
        for tile in attackTiles {
            layer(type: .highlight, insert: HighlightSprite.init(type: .targetMain), at: tile)
        }
        return true
    }
    
    func getAttackPatternTiles(attackPattern attack: BSAttackPattern, atTileCoord tileCoord: TileCoord) -> [TileCoord] {
        switch attack.pattern {
        case .point:
            return [tileCoord]
        case .cross(let range):
            return BSTilePlotter.getValidCrossPatternTiles(onGameBoard: self, withRange: range, atTileCoord: tileCoord)
        case .diamond(let range):
            return [tileCoord]
        case .square(let range):
            return BSTilePlotter.getValidSquarePatternTiles(onGameBoard: self, withRange: range, atTileCoord: tileCoord)
        }
    }
    
    func tryPlacingAttackPatternTiles(withTiles attackTiles: [TileCoord]) -> Bool {
        for tile in attackTiles {
            layer(type: .highlight, insert: HighlightSprite.init(type: .targetSplash), at: tile)
        }
        return true
    }
    
    private func tryInsertAttackPathHighLight(at tileCoord: TileCoord) -> Bool {
        if isValidWalkingTile(for: tileCoord) &&
            !layer(type: .highlight, isUnoccupiedAt: tileCoord) {
            layer(type: .highlight, insert: HighlightSprite(type: .movementStep), at: tileCoord)
            return true
        }
        return false
    }
    
    private func isValidHighlightTile(at tileCoord: TileCoord) -> Bool {
        return self.isValidAttackingTile(for: tileCoord) && highlightLayer.hasNodeNamed("attack", atCoord: tileCoord)
    }
    
}

