//
//  Presenter.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum Presenter {
    static func inject(_ component: ViewComponent) -> UIViewController {
        let controller: UIViewController
        
        switch component {
        case .colorPickerView:
            controller = ColorPickerViewController<ColorPickerPresentableView>()
            return controller
        case .onboarding:
            controller = OnboardingViewController()
            return controller
        case .sceneInspectorView:
            // MARK: - Separate this to a different view controller
            controller = AttributesInspectorViewController<SceneInspectorPresentableView>()
            return controller
        case .nodeInspectorView:
            controller = NodeInspectorViewController()
            return controller
        case .utilitiesView:
            controller = UtilitiesInspectorViewController()
            return controller
        case .documentBrowser:
            controller = DocumentBrowserViewController()
            return controller
        case .sceneActionsMenu:
            controller = SceneActionMenuViewController()
            return controller
        case .objectCatalog:
            controller = ObjectCatalogViewController()
            return controller
        case .presentation(let document):
            controller = PresentationViewController(scene: document)
            return controller
        case .nodeAnimationList:
            controller = NodeAnimationListViewController()
            return controller
        case .nodeAnimationMenu:
            controller = NodeAnimationMenuViewController()
            return controller
        case .moveAnimationAttributes(let animationAttributes):
            controller = MoveAnimationAttributesViewController(animationAttributes: animationAttributes)
            return controller
        case .rotateAnimationAttributes(let animationAttributes):
            controller = RotateAnimationAttributesViewController(animationAttributes: animationAttributes)
            return controller
        case .delayAnimationAttributes(let animationAttributes):
            controller = DelayAnimationAttributesViewController(animationAttributes: animationAttributes)
            return controller
        case .alertAnimationAttributes(attributes: let animationAttributes):
            controller = AlertAnimationAttributesViewController(animationAttributes: animationAttributes)
            return controller
        case .alertAnimationPopover:
            controller = AlertAnimationPopoverViewController()
            return controller
        }
    }
}
