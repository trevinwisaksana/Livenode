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
        switch component {
        case .colorPickerView:
            return AttributesInspectorViewController<ColorPickerView>()
        case .sceneInspectorView:
            return AttributesInspectorViewController<SceneInspectorPresentableView>()
        case .nodeInspectorView:
            return AttributesInspectorViewController<NodeInspectorView>()
        }
    }
}

enum ViewComponents: String {
    case colorPickerView
    case sceneInspectorView
    case nodeInspectorView
    
    static var all: [ViewComponents] {
        return [
            .colorPickerView,
            .sceneInspectorView,
            .nodeInspectorView
        ]
    }
}
