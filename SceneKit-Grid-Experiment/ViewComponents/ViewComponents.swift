//
//  ViewComponents.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

enum ViewComponents {
    case colorPickerView
    case sceneInspectorView
    case nodeInspectorView
    
    var all: [ViewComponents] {
        return [
            .colorPickerView,
            .sceneInspectorView,
            .nodeInspectorView
        ]
    }
}
