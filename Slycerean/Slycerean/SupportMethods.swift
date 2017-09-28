//
//  SupportMethods.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/13/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import UIKit

extension TileCoord: Equatable {}

struct TPConvert {
    static private var size = CGSize(width: 128, height: 128)
    
    static func setTileSize(to size: CGSize) {
        self.size = size
    }
    
    static func tileCoordForPosition(_ position: CGPoint) -> TileCoord {
        return TileCoord(col: Int(position.x / size.width), row: Int(position.y / size.height))
    }
    static func positionForTileCoord(_ tileCoord: TileCoord) -> CGPoint {
        return CGPoint(x: tileCoord.col * Int(size.width), y: tileCoord.row * Int(size.height))
    }
}

func ==(lhs: TileCoord, rhs: TileCoord) -> Bool {
    return lhs.col == rhs.col && lhs.row == rhs.row
}

func -(lhs: TileCoord, rhs: TileCoord) -> TileCoord {
    return TileCoord(col: lhs.col - rhs.col, row: lhs.row - rhs.row)
}

func ==(lhs: ShortestPathStep, rhs: ShortestPathStep) -> Bool {
    return lhs.position == rhs.position
}

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func point2DToIso(p:CGPoint) -> CGPoint {
    
    //invert y pre conversion
    var point = p * CGPoint(x:1, y:-1)
    
    //convert using algorithm
    point = CGPoint(x:(point.x - point.y), y: ((point.x + point.y) / 2))
    
    //invert y post conversion
    point = point * CGPoint(x:1, y:-1)
    
    return point
    
}
func pointIsoTo2D(p:CGPoint) -> CGPoint {
    
    //invert y pre conversion
    var point = p * CGPoint(x:1, y:-1)
    
    //convert using algorithm
    point = CGPoint(x:((2 * point.y + point.x) / 2), y: ((2 * point.y - point.x) / 2))
    
    //invert y post conversion
    point = point * CGPoint(x:1, y:-1)
    
    return point
    
}


internal extension CGFloat {
    
    /**
     Convert a float to radians.
     - returns: `CGFloat`
     */
    internal func radians() -> CGFloat {
        let b = CGFloat(Double.pi) * (self / 180)
        return b
    }
    
    /**
     Convert a float to degrees.
     - returns: `CGFloat`
     */
    internal func degrees() -> CGFloat {
        return self * 180.0 / CGFloat(Double.pi)
    }
    
    /**
     Clamp the CGFloat between two values. Returns a new value.
     - parameter v1: `CGFloat` min value.
     - parameter v2: `CGFloat` min value.
     - returns: `CGFloat` clamped result.
     */
    internal func clamped(_ minv: CGFloat, _ maxv: CGFloat) -> CGFloat {
        let min = minv < maxv ? minv : maxv
        let max = minv > maxv ? minv : maxv
        return self < min ? min : (self > max ? max : self)
    }
    
    /**
     Clamp the current value between min & max values.
     - parameter v1: `CGFloat` min value.
     - parameter v2: `CGFloat` min value.
     - returns: `CGFloat` clamped result.
     */
    internal mutating func clamp(_ minv: CGFloat, _ maxv: CGFloat) -> CGFloat {
        self = clamped(minv, maxv)
        return self
    }
    
    /**
     Returns a string representation of the value rounded to the current decimals.
     - parameter decimals: `Int` number of decimals to round to.
     - returns: `String` rounded display string.
     */
    internal func roundTo(_ decimals: Int=2) -> String {
        return String(format: "%.\(String(decimals))f", self)
    }
    
    /**
     Returns the value rounded to the nearest .5 increment.
     - returns: `CGFloat` rounded value.
     */
    internal func roundToHalf() -> CGFloat {
        let scaled = self * 10.0
        let result = scaled - (scaled.truncatingRemainder(dividingBy: 5))
        return result.rounded() / 10
    }
    
    internal static func random(_ range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (range.upperBound - range.lowerBound) + range.lowerBound
    }
}
