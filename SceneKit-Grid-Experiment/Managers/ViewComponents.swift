//
//  ViewManager.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum ViewComponents: String {
    case colorPickerView
    case sceneInspectorView
    
    static var all: [ViewComponents] {
        return [
            .colorPickerView,
            .sceneInspectorView
        ]
    }
    
    static func viewController(for indexPath: IndexPath) -> UIViewController {
        let components = ViewComponents.all[indexPath.section]
        let viewController: UIViewController
        switch components {
        case .colorPickerView:
            return ViewController<ColorPickerView>()
        case .sceneInspectorView:
            return ViewController<SceneInspectorView>()
        }
    
    }
    
}
