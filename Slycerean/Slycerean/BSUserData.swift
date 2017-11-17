//
//  BSUserData.swift
//  Slycerean
//
//  Created by Benjamin Su on 11/16/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

class BSUserData {
    
    static let shared = BSUserData()
    
    var name: String = "Sol"
    var coins: Int = 0
    var party: [GameUnit] = []
    
    private init() {
        // load from cache ?
        let unit1 = GameUnit(stats: BSCharacterStats(health: 30, energy: 2, actionSpeed: 4, level: 1, job: .warrior, jobLevels: [.warrior:1]), equipment: BSCharacterEquipment(weapon: "", armor: "", relic: ""))
        
        let unit2 = GameUnit(stats: BSCharacterStats(health: 22, energy: 15, actionSpeed: 4, level: 1, job: .wizard, jobLevels: [.wizard:1]), equipment: BSCharacterEquipment(weapon: "", armor: "", relic: ""))
        party = [unit1, unit2]
    }
    
    
    
}
