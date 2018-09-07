//
//  ViewComponent.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

enum ViewComponent {
    case colorPickerView
    case sceneInspectorView
    case nodeInspectorView
    case utilitiesView
    case fileCatalogView
    
    var all: [ViewComponent] {
        return [
            .colorPickerView,
            .sceneInspectorView,
            .nodeInspectorView,
            .utilitiesView,
            .fileCatalogView
        ]
    }
}
