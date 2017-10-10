//
//  GameView.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/6/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSGameView: SKView {
    
    var inputHandler: BSGameInputHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inputHandler = BSGameInputHandler(view: self)
//        inputHandler?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

