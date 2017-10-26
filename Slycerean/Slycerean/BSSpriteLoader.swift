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
    
    private var unitTextures = [BSGameUnitJob: SKTexture]()
    
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
    
    func unloadUnitTextures() {
        unitTextures.removeAll()
    }
    
}
