//
//  GameCamera.swift
//  Slycerean
//
//  Created by Benjamin Su on 9/24/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

public enum CameraZoomClamping: CGFloat {
    case none    = 0
    case half    = 2
    case quarter = 4
    case tenth   = 10
}

class GameCamera: SKCameraNode {
    
    unowned var world: SKNode
    internal var bounds: CGRect
    
    public var zoom: CGFloat = 1.0
    public var initialZoom: CGFloat = 1.0
    
    // movement constraints
    public var allowMovement: Bool = true
    public var allowZoom: Bool = true
    public var allowRotation: Bool = false
    public var allowPause: Bool = true
    
    // zoom constraints
    public var minZoom: CGFloat = 0.8
    public var maxZoom: CGFloat = 1.5
    public var isAtMaxZoom: Bool { return zoom == maxZoom }
    /// Clamp factor to alleviate cracks in tilemap.
    public var zoomClamping: CameraZoomClamping = .none {
        didSet {
            setCameraZoom(self.zoom)
        }
    }
    
    /// Gesture recognizer to recognize camera panning
    public var cameraPanned: UIPanGestureRecognizer!
    /// Gesture recognizer to recognize double taps
    public var sceneDoubleTapped: UITapGestureRecognizer!
    /// Gesture recognizer to recognize pinch actions
    public var cameraPinched: UIPinchGestureRecognizer!
    
    // locations
    fileprivate var focusLocation: CGPoint = CGPoint.zero
    fileprivate var lastLocation: CGPoint!
    
    // quick & dirty overlay node
    internal let overlay: SKNode = SKNode()
    public var showOverlay: Bool = true {
        didSet {
            guard oldValue != showOverlay else { return }
            overlay.isHidden = !showOverlay
        }
    }
    let hud = UnitHUDComponent()
    init(view: SKView, node: SKNode) {
        
        self.world = node
        self.bounds = view.bounds
        
        super.init()
        overlay.zPosition = 2000
        addChild(overlay)
        
        
        hud.position = CGPoint(x: -750, y: 500)
        overlay.addChild(hud)
        
        cameraPanned = UIPanGestureRecognizer(target: self, action: #selector(cameraPanned(_:)))
        cameraPanned.minimumNumberOfTouches = 1
        cameraPanned.maximumNumberOfTouches = 1
        view.addGestureRecognizer(cameraPanned)
        
        sceneDoubleTapped = UITapGestureRecognizer(target: self, action: #selector(sceneDoubleTapped(_:)))
        sceneDoubleTapped.numberOfTapsRequired = 2
        view.addGestureRecognizer(sceneDoubleTapped)
        
        // setup pinch recognizer
        cameraPinched = UIPinchGestureRecognizer(target: self, action: #selector(scenePinched(_:)))
        view.addGestureRecognizer(cameraPinched)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(to point: CGPoint, animated: Bool) {
        if animated {
            let moveAction = SKAction.move(to: point, duration: 0.5)
            self.run(moveAction)
        } else {
            self.position = point
        }
    }
    
    func move(by offset: CGPoint) {
        self.position = self.position - offset
    }
    internal func clampZoomValue(_ value: CGFloat, factor: CGFloat = 0) -> CGFloat {
        guard factor != 0 else { return value }
        let result = round(value * factor) / factor
        return (result > 0) ? result : value
    }
    public func setCameraZoom(_ scale: CGFloat, interval: TimeInterval=0) {
        // clamp scaling between min/max zoom
        var zoomClamped = scale.clamped(minZoom, maxZoom)
        
        // round zoom value to alleviate cracking
        zoomClamped = clampZoomValue(zoomClamped, factor: zoomClamping.rawValue)
        
        self.zoom = zoomClamped
        let zoomAction = SKAction.scale(to: zoomClamped, duration: interval)
        
        if (interval == 0) {
//            world.setScale(zoomClamped)
            setScale(zoomClamped)
        } else {
            run(zoomAction)
        }
        
        //        if let tilemap = (scene as? SKTiledScene)?.tilemap {
        //            tilemap.autoResize = false
        //        }
        
        //        // notify delegates
        //        for delegate in delegates {
        //            delegate.cameraZoomChanged(newZoom: zoomClamped)
        //        }
    }
    
    public func setCameraZoomAtLocation(scale: CGFloat, location: CGPoint) {
        setCameraZoom(scale)
        moveCamera(location: location, previous: position)
    }
    
    public func moveCamera(location: CGPoint, previous: CGPoint) {
        let dy = position.y - (location.y - previous.y)
        let dx = position.x - (location.x - previous.x)
        position = CGPoint(x: dx, y: dy)
        
        // notify delegates
        //        for delegate in delegates {
        //            delegate.cameraPositionChanged(newPosition: position)
        //        }
    }
    
    public func centerOn(scenePoint point: CGPoint, duration: TimeInterval=0) {
        defer {
            // notify delegates
            //            for delegate in self.delegates {
            //                delegate.cameraPositionChanged(newPosition: point)
            //            }
        }
        
        if duration == 0 {
            position = point
        } else {
            let moveAction = SKAction.move(to: point, duration: duration)
            moveAction.timingMode = .easeOut
            run(moveAction)
        }
    }
    
}

extension GameCamera {
    // MARK: - Gesture Handlers
    /**
     Update the scene camera when a pan gesture is recogized.
     - parameter recognizer: `UIPanGestureRecognizer` pan gesture recognizer.
     */
    @objc func cameraPanned(_ recognizer: UIPanGestureRecognizer) {
        guard (self.scene != nil),
            (allowMovement == true) else { return }
        
        if (recognizer.state == .began) {
            let location = recognizer.location(in: recognizer.view)
            lastLocation = location
        }
        
        if (recognizer.state == .changed) && (allowMovement == true) {
            if lastLocation == nil { return }
            let location = recognizer.location(in: recognizer.view)
            let difference = CGPoint(x: location.x - lastLocation.x, y: location.y - lastLocation.y)
            centerOn(scenePoint: CGPoint(x: Int(position.x - difference.x), y: Int(position.y - -difference.y)))
            lastLocation = location
        }
    }
    
    /**
     Handler for double taps.
     - parameter recognizer: `UITapGestureRecognizer` tap gesture recognizer.
     */
    @objc func sceneDoubleTapped(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.ended) {
            let location = recognizer.location(in: recognizer.view)
            //            for delegate in self.delegates {
            //                recognizer.numberOfTouches
            //
            //                delegate.sceneDoubleTapped(location: location)
            //            }
            hud.updateUI()
        }
    }
    
    /**
     Update the camera scale in the scene.
     - parameter recognizer: `UIPinchGestureRecognizer`
     */
    @objc func scenePinched(_ recognizer: UIPinchGestureRecognizer) {
        guard let scene = self.scene,
            (allowZoom == true) else { return }
        
        if recognizer.state == .began {
            let location = recognizer.location(in: recognizer.view)
            focusLocation = scene.convertPoint(fromView: location)  // correct
            centerOn(scenePoint: focusLocation)
        }
        
        if recognizer.state == .changed {
            let invertedScale = (-recognizer.scale + 2)
            zoom *= invertedScale
            
            // set the world scaling here
            setCameraZoomAtLocation(scale: xScale * invertedScale, location: focusLocation)
            recognizer.scale = 1
        }
    }
}
