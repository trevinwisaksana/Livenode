//
//  Constants.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 23/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct Constants {
    struct Controller {
        static let objectCatalog = "ObjectCatalogController"
        static let popoverMenu = "PopoverMenuController"
        static let objectAttribute = "ObjectAttributeController"
        static let utilities = "UtilitiesController"
    }
}

enum Action: String {
    case cut
    case copy
    case delete
    case paste
    case move
    case pin
    case animate
    
    var capitalized: String {
        return rawValue.capitalized
    }
}
