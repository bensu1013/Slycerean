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
    
//    private let tileSize: CGSize
    
//    init(name: String) {
//
////        self.tileSize = tileSize
//        
//        super.init(name: name)
//
//        // Loop through the rows
////        for (row, rowData) in tileData.enumerated() {
////
////            // Note: In Sprite Kit (0, 0) is a the bottom of the screen,
////            // so we need to read this file upside down.
////            let tileRow = rows - row - 1
////
////            // Loop through the columns in the current row
////            for (column, value) in rowData.enumerated() {
////                if let tileName = tileNames[0] {
////                    let tile = Tile(name: tileName + "\(value)")
////                    tile.anchorPoint = CGPoint.zero
////                    tile.position = CGPoint(x: tileSize.width * CGFloat(column), y: tileSize.height * CGFloat(tileRow))
////                    self.addChild(tile)
////                }
////            }
////        }
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder) is not used in this app")
//    }
    
//
//    name" : "Floor",
//    "tileType" : "Grass_Grid_",
//    "tileNames" : [
//    "Center",            //0
//    "Up",                //1
//    "Down",              //2
//    "Left",              //3
//    "Right",             //4
//    "UpLeft",            //5
//    "UpRight",           //6
//    "DownLeft",          //7
//    "DownRight",         //8
//    "UpLeftInterior",    //9
//    "UpRightInterior",   //10
//    "DownLeftInterior",  //11
//    "DownRightInterior"  //12
//    ],
//    "tiles" : [//0   1   2   3   4   5   6   7   8   9  10  11  12  13  14
//    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //0
//    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //1
//    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //2
//    [00, 09, 02, 02, 02, 10, 00, 00, 00, 00, 00, 00, 00, 00, 00], //3
//    [00, 04, NA, NA, NA, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00], //4
//    [00, 04, NA, NA, NA, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00], //5
//    [02, 08, NA, 05, 01, 12, 00, 00, 00, 00, 00, 00, 00, 00, 00], //6
//    [NA, NA, NA, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //7
//    [NA, NA, NA, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //8
//    [NA, NA, 05, 12, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //9
//    [NA, 05, 12, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //10
//    [NA, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //11
//    [01, 12, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //12
//    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], //13
//    [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]  //14
//    ]
//},
    func loadSublayer(withData layerData: [String: Any], atZPosition: Int) {
        guard let name = layerData["name"] as? String,
            let tileType = layerData["tileType"] as? String,
            let tileNames = layerData["tileNames"] as? [String],
            let tiles = layerData["tiles"] as? [[String]] else { return }
        
        for (row, rowData) in tiles.enumerated() {
            let rows = tiles.count - row - 1
            for (col, tile) in rowData.enumerated() {
                if let number = Int(tile) {
                    if name == "Water" {
                        createWaterNode(withName: tileType + tileNames[number], at: TileCoord(col: col, row: rows))
                    } else {
//                        let texture = SKTexture(imageNamed: tileType + tileNames[number])
                        let sprite = Tile(name: tileType + tileNames[number])
                        insertSprite(node: sprite, at: TileCoord(col: col, row: rows))
                    }
                }
            }
        }
    }
    
    func createWaterNode(withName name: String, at tileCoord: TileCoord) {
        if name == "Water_Grid_Center" {
            let sprite = Tile(name: name)
            insertSprite(node: sprite, at: tileCoord)
            return
        }
        var textures = [SKTexture]()
        for x in 0...29 {
            textures.append(SKTexture(imageNamed: name + "_Frame_\(x)"))
        }
        let sprite = SKSpriteNode(color: .clear, size: CGSize(width: 128, height: 128))
        sprite.anchorPoint = .zero
        let waves = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2))
        sprite.run(waves)
        insertSprite(node: sprite, at: tileCoord)
    }
    
}
