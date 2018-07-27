//
//  Presenter.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum Presenter {
    static func inject(_ component: ViewComponents) -> UIViewController {
        let controller: UIViewController
        
        switch component {
        case .colorPickerView:
            controller = AttributesInspectorViewController<ColorPickerView>()
            controller.title = "Color Palette"
            return controller
        case .sceneInspectorView:
            controller = AttributesInspectorViewController<SceneInspectorPresentableView>()
            controller.title = "Scene Attributes"
            return controller
        case .nodeInspectorView:
            controller = AttributesInspectorViewController<NodeInspectorPresentableView>()
            controller.title = "Node Attributes"
            return controller
        }
    }
}
