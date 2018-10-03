//
//  ObjectCatalogViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

class ObjectCatalogViewControllerDelegate: NSObject, ObjectCatalogPresentableViewDelegate {
    func objectCatalogPresentableView(_ objectCatalogPresentableView: ObjectCatalogPresentableView, didSelectNodeModel model: NodeModel) {
        NotificationCenter.default.post(name: Notification.Name.ObjectCatalogDidSelectNodeModel, object: model)
    }
}
