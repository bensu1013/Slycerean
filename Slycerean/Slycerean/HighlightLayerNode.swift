//
//  HighlightLayerNode.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/5/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

typealias TileAndType = (tileCoord: TileCoord, type: HighlightType)

class HighlightLayerNode: LayerNode {
    
    private var tileTypes = [TileAndType]()
    
    var getTileTypes: [TileAndType] {
        return tileTypes
    }
    
    func addHighlights(at tileAndTypes: [TileAndType]) {
        tileTypes = tileAndTypes
        for tileAndType in tileAndTypes {
            removeChildren(at: tileAndType.tileCoord)
            
            let highlight = HighlightSprite(type: tileAndType.type)
            insertSprite(node: highlight, at: tileAndType.tileCoord)
        }
    }
    
    func removeHighlights() {
        tileTypes.removeAll()
        removeAllChildren()
    }
    
}
