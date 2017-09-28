//
//  Array2D.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/10/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

struct CollisionMap {
    private let columns: Int
    private let rows: Int
    private var array: [Int]
    
    init(columns: Int, rows: Int, map: [Int]) {
        self.columns = columns
        self.rows = rows
        array = map
    }
    
    subscript(tileCoord: TileCoord) -> Int {
        get {
            return array[(rows - tileCoord.row - 1)*columns + tileCoord.col]
        }
        set {
            array[(rows - tileCoord.row - 1)*columns + tileCoord.col] = newValue
        }
    }
    
    func isValidMoveTile() {
        
    }
    
}
