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
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectCutButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.cut.capitalized)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectCopyButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.copy.capitalized)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectPasteButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.paste.capitalized)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectDeleteButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.delete.capitalized)
    }
}
