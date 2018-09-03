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
    
    struct NotificationCenter {
        static let nodeColorModifiedKey = Notification.Name("NSNotification.NodeColorModified")
    }
    
}

enum Action: String {
    case move
    case copy
    case delete
    case paste
    case cut
    
    var capitalized: String {
        return rawValue.capitalized
    }
}
