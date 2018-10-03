//
//  SceneEditorDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol SceneEditorDelegateProtocol: class {
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView)
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayUtilitiesInspectorWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayObjectCatalogWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem)
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonFrom notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didModifyNodeColor notification: Notification, for scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesMovedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
}

class SceneEditorViewControllerDelegate: NSObject, SceneEditorDelegateProtocol {
    
    // MARK: - Presenting
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView) {
        let location = sender.location(in: controller.view)
        
        if sceneView.hitTest(location, options: nil).first?.node == nil {
            return
        }
        
        let sceneActionsMenuController = Presenter.inject(.sceneActionsMenu)
        
        sceneActionsMenuController.modalPresentationStyle = .popover
        sceneActionsMenuController.popoverPresentationController?.permittedArrowDirections = .down
        sceneActionsMenuController.popoverPresentationController?.delegate = self
        
        let touchLocation = sender.location(in: controller.view)
        
        guard let height = controller.view?.frame.height else {
            fatalError("Unable to get the height of the view controller.")
        }
        
        let yOffset = height * 0.05
        let sourceRect = CGRect(x: 0, y: yOffset, width: 1.0, height: 100.0)
        
        let touchView = UIView(frame: sourceRect)
        controller.view.addSubview(touchView)
        
        touchView.backgroundColor = .clear
        touchView.center = touchLocation
        
        sceneActionsMenuController.popoverPresentationController?.sourceRect = sourceRect
        sceneActionsMenuController.popoverPresentationController?.sourceView = touchView
        
        controller.present(sceneActionsMenuController, animated: true) {
            touchView.removeFromSuperview()
        }
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayUtilitiesInspectorWith sender: UIBarButtonItem) {
        let utilitiesController = Presenter.inject(.utilitiesView)
        
        utilitiesController.modalPresentationStyle = .popover
        utilitiesController.popoverPresentationController?.permittedArrowDirections = .up
        utilitiesController.popoverPresentationController?.delegate = self
        utilitiesController.popoverPresentationController?.barButtonItem = sender
        
        controller.present(utilitiesController, animated: true, completion: nil)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayObjectCatalogWith sender: UIBarButtonItem) {
        let objectCatalogController = Presenter.inject(.objectCatalog)
        
        objectCatalogController.modalPresentationStyle = .popover
        objectCatalogController.popoverPresentationController?.permittedArrowDirections = .up
        objectCatalogController.popoverPresentationController?.delegate = self
        objectCatalogController.popoverPresentationController?.barButtonItem = sender
        
        controller.present(objectCatalogController, animated: true, completion: nil)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem) {
        let navigationController = UINavigationController()
        let viewController: UIViewController
        
        if State.nodeSelected != nil {
            viewController = Presenter.inject(.nodeInspectorView)
        } else {
            viewController = Presenter.inject(.sceneInspectorView)
        }
        
        navigationController.viewControllers = [viewController]
        
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.popoverPresentationController?.delegate = self
        navigationController.popoverPresentationController?.barButtonItem = sender
        
        controller.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Scene Action Menu
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonFrom notification: Notification, for scene: DefaultScene) {
        guard let action = notification.object as? String else {
            return
        }
        
        switch action {
        case Action.cut.capitalized:
            scene.testNode.copy()
            scene.testNode.removeFromParentNode()
        case Action.copy.capitalized:
            scene.testNode.copy()
        case Action.paste.capitalized:
            break
        case Action.delete.capitalized:
            scene.testNode.removeFromParentNode()
        case Action.move.capitalized:
            scene.testNode.isMovable = true
        case Action.pin.capitalized:
            scene.testNode.isMovable = false
        default:
            break
        }
        
        controller.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Color Picker
    
    func sceneEditor(_ controller: SceneEditorViewController, didModifyNodeColor notification: Notification, for scene: DefaultScene) {
        if let color = notification.object as? UIColor {
            scene.modifyNode(color: color)
        }
    }
    
    // MARK: - Touches
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesMovedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        // TODO: Move this code to the DefaultScene
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        if scene.didSelectTargetNode {
            let nodeXPos = nodeSelected.position.x
            let nodeYPos = nodeSelected.position.y
            var nodeZPos = nodeSelected.position.z
            
            if nodeZPos >= 0.5 {
                nodeZPos = 0
            }
            
            // TESTING
            if scene.testNode.isMovable {
//                nodeSelected.position = SCNVector3(nodeXPos, nodeYPos, nodeZPos + 1)
                scene.testNode.position = SCNVector3(nodeXPos, nodeYPos, nodeZPos + 0.5)
                sceneView.allowsCameraControl = false
            }
        }
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        // TODO: Move this code to the DefaultScene
        scene.nodeSelected = sceneView.hitTest(location, options: nil).first?.node
        
        if scene.nodeSelected?.name == "Floor" || scene.nodeSelected == nil {
//            unhighlight(lastNodeSelected)
            return
        }
        
        if scene.nodeSelected?.name == "testNode" {
            scene.didSelectTargetNode = true
            State.nodeSelected = Node(node: scene.nodeSelected)
//            highlight(nodeSelected)
        } else {
            scene.didSelectTargetNode = false
        }
        
        scene.lastNodeSelected = scene.nodeSelected
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        sceneView.allowsCameraControl = true
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension SceneEditorViewControllerDelegate: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}