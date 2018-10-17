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
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.cut)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectCopyButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.copy)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectPasteButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.paste)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectDeleteButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.delete)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectMoveButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.move)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectPinButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.pin.capitalized)
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectAnimateButton button: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.SceneActionMenuDidSelectButton, object: Action.animate.capitalized)
    }
}
