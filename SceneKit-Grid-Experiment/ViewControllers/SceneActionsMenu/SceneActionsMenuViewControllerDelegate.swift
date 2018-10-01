//
//  SceneActionsMenuViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 01/10/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol SceneActionsMenuDelegateProtocol: class {
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuFor node: SCNNode, with sender: UILongPressGestureRecognizer)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayUtilitiesInspectorWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayObjectCatalogWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem)
}

class SceneActionsMenuViewControllerDelegate: NSObject, SceneActionsMenuViewDelegate {
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectCutButton button: UIButton) {
        
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectCopyButton button: UIButton) {
        
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectPasteButton button: UIButton) {
        
    }
    
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectDeleteButton button: UIButton) {
        
    }
}
