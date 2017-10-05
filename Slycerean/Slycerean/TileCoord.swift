//
//  TileCoord.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/4/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

class TileCoord {
    var col: Int
    var row: Int
    init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    var top: TileCoord {
        return TileCoord(col: col, row: row + 1)
    }
    var left: TileCoord {
        return TileCoord(col: col - 1, row: row)
    }
    var right: TileCoord {
        return TileCoord(col: col + 1, row: row)
    }
    var bottom: TileCoord {
        return TileCoord(col: col, row: row - 1)
    }
    var topLeft: TileCoord {
        return TileCoord(col: col - 1, row: row + 1)
    }
    var topRight: TileCoord {
        return TileCoord(col: col + 1, row: row + 1)
    }
    var bottomLeft: TileCoord {
        return TileCoord(col: col - 1, row: row - 1)
    }
    var bottomRight: TileCoord {
        return TileCoord(col: col + 1, row: row - 1)
    }
    func at(direction: Direction) -> TileCoord {
        switch direction {
        case .up:
            return top
        case .down:
            return bottom
        case .left:
            return left
        case .right:
            return right
        }
    }
}
