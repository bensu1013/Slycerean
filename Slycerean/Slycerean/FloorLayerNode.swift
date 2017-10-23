//
//  TiledLayerNode.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/11/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class FloorLayerNode: LayerNode {

    func loadSublayer(withData layerData: [String: Any], atZPosition: Int) {
        guard let name = layerData["name"] as? String,
            let tileType = layerData["tileType"] as? String,
            let tiles = layerData["tiles"] as? [[String]] else { return }
        
        for (row, rowData) in tiles.enumerated() {
            let rows = tiles.count - row - 1
            for (col, tile) in rowData.enumerated() {
                let sprite = Tile(name: tileType + tile)
                insertSprite(node: sprite, at: TileCoord(col: col, row: rows))
            }
        }
    }

    
}
