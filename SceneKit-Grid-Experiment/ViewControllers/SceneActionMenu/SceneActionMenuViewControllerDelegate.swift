//
//  SceneActionMenuViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 01/10/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

class SceneActionMenuViewControllerDelegate: NSObject, SceneActionsMenuViewDelegate {
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectSceneActionButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: button.titleLabel?.text)
    }
}
