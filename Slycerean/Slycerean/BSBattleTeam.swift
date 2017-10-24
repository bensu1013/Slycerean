//
//  BSBattleTeam.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/23/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation

enum BSTeam {
    case user, bot, neutral
}

class BSBattleTeam {
    var team: BSTeam
    var party: [BSBattleUnit]
    
    init(team: BSTeam, party: [BSBattleUnit]) {
        self.team = team
        self.party = party
    }
    
    
    
}
