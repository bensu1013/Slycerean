//
//  BSAIBattleUnit.swift
//  Slycerean
//
//  Created by Benjamin Su on 11/2/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSAIBattleUnit: BSBattleUnit {
    
    func takeTurn(board: GameBoard, completion: @escaping () -> ()) {
        let moveTiles = BSTilePlotter.getValidWalkingTiles(onGameBoard: board, forUnit: self)
        let randMove = Int(arc4random_uniform(UInt32(moveTiles.count)))
        board.tryPlacingMovementTiles(for: self)
        
        self.moveComponent.moveTo(moveTiles[randMove]) {
            completion()
        }
    }
    
}
