//
//  BSBattleSystem.swift
//  Slycerean
//
//  Created by Benjamin Su on 11/2/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

class BSBattleSystem {
    
    var userTeam: BSBattleTeam
    var aiTeam: BSBattleTeam
    
    var allUnits = [BSBattleUnit]()
    weak var currentActiveUnit: BSBattleUnit?
    
    init(userTeam: BSBattleTeam, aiTeam: BSBattleTeam) {
        
        self.userTeam = userTeam
        self.aiTeam = aiTeam
        
        self.allUnits = userTeam.startBattle() + aiTeam.startBattle()
        
    }
    
    func startBattle() {
        findNextActiveUnit()
        
    }
    
    func findNextActiveUnit() {
        while currentActiveUnit == nil {
            if allUnits[0].actionSpeedAccumulated >= 100 {
                currentActiveUnit = allUnits[0]
            }
            for unit in allUnits {
                unit.actionSpeedAccumulated += unit.actionSpeed
            }
            allUnits.sort(by: { $0.actionSpeedAccumulated > $1.actionSpeedAccumulated })
        }
    }
    
    func checkBattleconditions() {
        // is one team defeated?
        
    }
    
}
