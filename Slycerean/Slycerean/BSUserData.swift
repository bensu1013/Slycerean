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
    
    var coins: Int = 0
    var party: [BSGameUnit] = []
    
    private init() {
        // load from cache ?
        let unit1 = BSGameUnit(stats: BSCharacterStats(name: "Sol", health: 30, energy: 2, actionSpeed: 4, level: 1, job: .warrior), equipment: BSCharacterEquipment(weapon: "", armor: "", relic: ""))
        
        party = [unit1]
    }
    
    
    
}
