//
//  NotificationNames.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 01/10/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static var SceneActionMenuDidSelectButton: Notification.Name {
        return Notification.Name(rawValue: "SceneActionMenuDidSelectButton")
    }
    
    public static var ColorPickerDidModifyNodeColor: Notification.Name {
        return Notification.Name("ColorPickerDidModifyNodeColor")
    }
    
    public static var ObjectCatalogDidSelectNodeModel: Notification.Name {
        return Notification.Name("ObjectCatalogDidSelectNodeModel")
    }
    
    public static var NodeAnimationMenuDidSelectAnimation: Notification.Name {
        return Notification.Name("NodeAnimationMenuDidSelectAnimation")
    }
}
