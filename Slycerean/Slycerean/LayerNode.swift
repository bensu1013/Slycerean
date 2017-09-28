//
//  LayerNode.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/10/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class LayerNode: SKNode {
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    /// Get a list of nodes found at the coord in this layer
    func nodes(at tileCoord: TileCoord) -> [SKNode] {
        let nodes = self.nodes(at: CGPoint(x: tileCoord.col * 128 + 2, y: tileCoord.row * 128 + 2))
        return nodes
    }
    
    func hasNodeNamed(_ name: String, atCoord tileCoord: TileCoord) -> Bool {
        return self.nodes(at: tileCoord).contains(where: { $0.name == name })
    }
    
    func insertSprite(node: SKNode, at tileCoord: TileCoord) {
        node.position = CGPoint(x: tileCoord.col * 128, y: tileCoord.row * 128)
        self.addChild(node)
    }
    
    func removeChildren(at tileCoord: TileCoord) {
        let nodes = self.nodes(at: tileCoord)
        self.removeChildren(in: nodes)
    }

}
