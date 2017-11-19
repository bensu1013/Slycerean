//
//  BSGameInputHandler.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/9/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import SpriteKit
import UIKit


protocol BSGameInputHandlerDelegate: class {
    func handlePanAction(_ recognizer: UIPanGestureRecognizer)
    func handlePinchAction(_ recognizer: UIPinchGestureRecognizer)
    func handleTapAction(_ recognizer: UITapGestureRecognizer)
}


class BSGameInputHandler {
    
    weak var delegate: BSGameInputHandlerDelegate?
    
    init(view: SKView) {
        view.addGestureRecognizer(createPanGesture())
        view.addGestureRecognizer(createPinchGesture())
        view.addGestureRecognizer(createTapGesture())
    }
    
    func createPanGesture() -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        return pan
    }
    
    func createPinchGesture() -> UIPinchGestureRecognizer {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        return pinch
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.numberOfTapsRequired = 1
        return tap
    }
    
    @objc func panAction(_ recognizer: UIPanGestureRecognizer)  {
        delegate?.handlePanAction(recognizer)
    }
    @objc func pinchAction(_ recognizer: UIPinchGestureRecognizer) {
        delegate?.handlePinchAction(recognizer)
    }
    @objc func tapAction(_ recognizer: UITapGestureRecognizer) {
        delegate?.handleTapAction(recognizer)
    }
}
