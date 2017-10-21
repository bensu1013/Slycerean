//
//  HighlightLayerNode.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/5/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

typealias TileAndHighlightType = (tileCoord: TileCoord, type: HighlightType)

class HighlightLayerNode: LayerNode {
    
    private var groupedHighlightTiles = [TileCoord:[TileAndHighlightType]]()
    
    
    
    
    var getGroupedHighlightTiles: [TileCoord:[TileAndHighlightType]] {
        return groupedHighlightTiles
    }
    
    func addHighlights(at tileCoord: TileCoord, with groupedTiles: [TileAndHighlightType]) {
        groupedHighlightTiles[tileCoord] = groupedTiles
        for tileAndType in groupedTiles {
            removeChildren(at: tileAndType.tileCoord)
            let highlight = HighlightSprite(type: tileAndType.type)
            insertSprite(node: highlight, at: tileAndType.tileCoord)
        }
    }
    
    func removeHighlights() {
        groupedHighlightTiles.removeAll()
        removeAllChildren()
    }
    
}
