//
//  BSGameHUD.swift
//  Slycerean
//
//  Created by Benjamin Su on 10/18/17.
//  Copyright © 2017 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit

class BSGameHUD: SKNode {
    weak var gameScene: GameScene?
    var confirmationComponent: ConfirmationHUDComponent
    var actionMenuComponent: ActionHUDComponent
    var selectedUnitComponent: UnitHUDComponent
    var targetedUnitComponent: UnitHUDComponent
    
    required init(gameSceneSize size: CGSize) {
        
        confirmationComponent = ConfirmationHUDComponent(sceneSize: size)
        actionMenuComponent = ActionHUDComponent()
        selectedUnitComponent = UnitHUDComponent(size: CGSize(width: size.width / 3, height: size.height / 4))
        targetedUnitComponent = UnitHUDComponent(size: CGSize(width: size.width / 3, height: size.height / 4))
        
        super.init()
        
        selectedUnitComponent.position = CGPoint(x: -size.width/2, y: size.height/2)
        targetedUnitComponent.position = CGPoint(x: size.width/2 - targetedUnitComponent.size.width,
                                                 y: size.height/2)
        actionMenuComponent.position = CGPoint(x: -size.width/2,
                                               y: -size.height/2)
        confirmationComponent.position = .zero
        
        addChild(selectedUnitComponent)
        addChild(targetedUnitComponent)
        addChild(actionMenuComponent)
        addChild(confirmationComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        selectedUnitComponent.updateUI()
        targetedUnitComponent.updateUI()
    }
    
    func setGameScene(_ gameScene: GameScene) {
        self.gameScene = gameScene
        actionMenuComponent.setupHUDFor(scene: gameScene)
    }
    
    func setSelectedUnitHud(with unit: BSBattleUnit) {
        selectedUnitComponent.setupHUDFor(unit: unit)
        var basicIconName: String
        switch unit.classJob {
        case .warrior:
            basicIconName = "Basic-Slash"
        case .rogue:
            basicIconName = "Basic-Stab"
        case .wizard:
            basicIconName = "Basic-Bolt"
        case .ranger:
            basicIconName = "Basic-Shoot"
        }
        actionMenuComponent.primaryActionBar.loadTextureForButton(withTexture: BSSpriteLoader.shared.loadIconTexture(forName: basicIconName), atIndex: 0)
    }
    
    func setTargetedUnitHud(with unit: BSBattleUnit) {
        targetedUnitComponent.setupHUDFor(unit: unit)
    }
    
    func showConfirmation(with title: String) {
        confirmationComponent.showAlert(titled: title)
    }
    
    func tryActionWithTap(on point: CGPoint) -> Bool {
        return actionMenuComponent.tryTappingButton(onPoint: point)
    }
    
    func tryConfirmWithTap(on point: CGPoint) -> Bool? {
        return confirmationComponent.tryConfirmWithTap(on: point)
    }
    
}
