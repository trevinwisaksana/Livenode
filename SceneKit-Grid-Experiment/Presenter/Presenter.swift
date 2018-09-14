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
        case .sceneInspectorView:
            controller = AttributesInspectorViewController<SceneInspectorPresentableView>()
            return controller
        case .nodeInspectorView:
            controller = AttributesInspectorViewController<NodeInspectorPresentableView>()
            return controller
        case .utilitiesView:
            controller = UtilitiesViewController<UtilitiesPresentableView>()
            return controller
        case .fileCatalogView:
            // TODO: Inject presentable view
            controller = FileMenuViewController<FileMenuPresentableView, FileMenuNavigationItem>()
            return controller
        }
    }
}
