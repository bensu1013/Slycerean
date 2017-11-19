//
//  BSSpriteLoader.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/25/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSSpriteLoader {
    static var shared = BSSpriteLoader()
    private init() {}
    
    private var tileTextures = [String:SKTexture]()
    private var unitTextures = [BSGameUnitJob: SKTexture]()
    private var iconTextures = [String:SKTexture]()
    
    func loadTileTexture(forName name: String) -> SKTexture {
        if let tileTexture = tileTextures[name] {
            return tileTexture
        } else {
            let tileTexture = SKTexture(imageNamed: name)
            tileTextures[name] = tileTexture
            return tileTexture
        }
    }
    
    func loadIconTexture(forName name: String) -> SKTexture {
        if let iconTexture = iconTextures[name] {
            return iconTexture
        } else {
            let iconTexture = SKTexture(imageNamed: name)
            iconTextures[name] = iconTexture
            return iconTexture
        }
    }
    
    func loadUnitSpriteSheet(for job: BSGameUnitJob) -> SpriteSheet {
        if let jobTexture = unitTextures[job] {
            return SpriteSheet(texture: jobTexture, columns: 6, rows: 3)
        } else {
            var unitTexture: SKTexture
            switch job {
            case .warrior:
                unitTexture = SKTexture(imageNamed: "Character_Hero_Warrior")
            case .wizard:
                unitTexture = SKTexture(imageNamed: "Character_Hero_Priest")
            case .ranger:
                unitTexture = SKTexture(imageNamed: "Character_Hero_Archer")
            case .rogue:
                unitTexture = SKTexture(imageNamed: "Character_Monster_Boss")
            }
            unitTextures[job] = unitTexture
            return SpriteSheet(texture: unitTexture, columns: 6, rows: 3)
        }
    }
    
    func unloadTileTextures() {
        tileTextures.removeAll()
    }
    
    func unloadIconTextures() {
        iconTextures.removeAll()
    }
    
    func unloadUnitTextures() {
        unitTextures.removeAll()
    }
    
}







