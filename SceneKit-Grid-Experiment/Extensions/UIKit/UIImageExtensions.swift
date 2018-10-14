//
//  UIImageExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

// MARK: - Convience Initializer

extension UIImage {
    convenience init(named imageAsset: ImageAsset, in bundle: Bundle? = nil, compatibleWith traitCollection: UITraitCollection? = nil) {
        self.init(named: imageAsset.rawValue, in: bundle, compatibleWith: traitCollection)!
    }
}

enum ImageAsset: String {
    case objectCatalogButton
    case createScene
    case playButton
    case nodeInspectorButton
    case utilitiesInspectorButton
    case nextIndicator
    case boxWireframe
    case undoButton
    case animationMenuButton
}
