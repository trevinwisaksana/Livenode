//
//  ViewComponent.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

enum ViewComponent {
    case colorPickerView
    case sceneInspectorView
    case nodeInspectorView
    case utilitiesView
    
    case onboarding
    case documentBrowser
    case sceneActionsMenu(isNodeSelected: Bool)
    case objectCatalog
    case presentation(scene: DefaultScene)
    
    case nodeAnimationList
    case nodeAnimationMenu
    case moveAnimationAttributes(attributes: MoveAnimationAttributes)
    case rotateAnimationAttributes(attributes: RotateAnimationAttributes)
    case delayAnimationAttributes(attributes: DelayAnimationAttributes)
    case speechBubbleAnimationAttributes(attributes: SpeechBubbleAnimationAttributes)
    case alertAnimationPopover
}
