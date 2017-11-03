//
//  BSBattleTeam.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/23/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

enum BSTeam {
    case user, ai
    
    var opposingTeam: BSTeam {
        return self == BSTeam.user ? BSTeam.ai : BSTeam.user
    }
    
}

class BSBattleTeam {
    var team: BSTeam
    var party: [BSBattleUnit]
    
    init(team: BSTeam, party: [BSBattleUnit]) {
        self.team = team
        self.party = party
        for member in self.party {
            member.team = team
        }
    }
    
    func startBattle() -> [BSBattleUnit] {
        for member in party {
            member.actionSpeedAccumulated = Int(arc4random_uniform(20)) + 1
        }
        return party
    }
    
    
}
