//
//  TiledLayerNode.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/11/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class TiledLayerNode: LayerNode {
    
    private let tileSize: CGSize
    
    init(name: String, tileData: [[Int]], columns: Int, rows: Int, tileNames: [Int : String], tileSize: CGSize) {

        self.tileSize = tileSize
        
        super.init(name: name)
        
        // Loop through the rows
        for (row, rowData) in tileData.enumerated() {
            
            // Note: In Sprite Kit (0, 0) is a the bottom of the screen,
            // so we need to read this file upside down.
            let tileRow = rows - row - 1
            
            // Loop through the columns in the current row
            for (column, value) in rowData.enumerated() {
                if let tileName = tileNames[0] {
                    let tile = Tile(name: tileName + "\(value)")
                    tile.anchorPoint = CGPoint.zero
                    tile.position = CGPoint(x: tileSize.width * CGFloat(column), y: tileSize.height * CGFloat(tileRow))
                    self.addChild(tile)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
}
