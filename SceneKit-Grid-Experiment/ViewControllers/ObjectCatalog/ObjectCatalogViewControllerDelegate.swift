//
//  ObjectCatalogViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

class ObjectCatalogViewControllerDelegate: NSObject, ObjectCatalogViewDelegate {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectModel model: NodeModel) {
        NotificationCenter.default.post(name: Notification.Name.ObjectCatalogDidSelectNodeModel, object: model)
    }
}

// MARK: - Node Selection

extension ObjectCatalogViewControllerDelegate {
    func didSelectMode(at view: ObjectCatalogView, with sender: UITapGestureRecognizer) {
        let location = sender.location(in: view.sceneView)
        
        guard let nodeSelected = view.sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        view.didSelectModel(sender, withType: nodeSelected.type)
    }
}
