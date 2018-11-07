//
//  SceneEditorDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol SceneEditorViewControllerDelegateProtocol: class {
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayPresentationViewWith scene: DefaultScene, using sender: UIBarButtonItem)
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayUtilitiesInspectorWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayObjectCatalogWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayNodeAnimationListWith sender: UIBarButtonItem)
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeAnimationUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didModifyNodeColorUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeModelUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didTapDoneEditingMoveAnimationButtonForScene scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapPlayAnimationButtonWith sender: UIBarButtonItem, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditingAnimation sender: UIBarButtonItem, for scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didAddAlertAnimation animation: AlertAnimationAttributes, for scene: DefaultScene, in sceneView: SCNView)
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesMovedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
}

protocol SceneEditorDocumentDelegate: class {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didUpdateSceneContent scene: DefaultScene)
}

class SceneEditorViewControllerDelegate: NSObject, SceneEditorViewControllerDelegateProtocol {
    
    // MARK: - Presenting
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView) {
        let location = sender.location(in: controller.view)
        
        // TODO: Create a method in Scene View that determines if a node or a floor is selected
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
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayPresentationViewWith scene: DefaultScene, using sender: UIBarButtonItem) {
        let presentationController = Presenter.inject(.presentation(scene: scene))
        controller.present(presentationController, animated: true, completion: nil)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayNodeAnimationListWith sender: UIBarButtonItem) {
        let nodeAnimationListController = Presenter.inject(.nodeAnimationList)

        let navigationController = UINavigationController()
        
        navigationController.viewControllers = [nodeAnimationListController]
        
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.popoverPresentationController?.delegate = self
        navigationController.popoverPresentationController?.barButtonItem = sender
        
        controller.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Scene Action Menu
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonUsing notification: Notification, for scene: DefaultScene) {
        guard let action = notification.object as? Action else {
            return
        }
        
        switch action {
        case .animate:
            controller.setupAnimationNavigationItems()
            scene.setNodeAnimationTarget()
        case .move:
            controller.panGesture.isEnabled = false
            scene.didSelectScene(action: action)
        case .pin:
            controller.panGesture.isEnabled = true
        default:
            scene.didSelectScene(action: action)
        }
        
        controller.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Color Picker
    
    func sceneEditor(_ controller: SceneEditorViewController, didModifyNodeColorUsing notification: Notification, for scene: DefaultScene) {
        if let color = notification.object as? UIColor {
            scene.modifyNodeColor(to: color)
        }
    }
    
    // MARK: - Object Catalog
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeModelUsing notification: Notification, for scene: DefaultScene) {
        if let nodeModel = notification.object as? NodeModel {
            switch nodeModel {
            case .box:
                scene.insertBox()
            case .sphere:
                scene.insertSphere()
            case .pyramid:
                scene.insertPyramid()
            case .car:
                scene.insertCar()
            case .house:
                scene.insertHouse()
            }
        }
    }
    
    // MARK: - Node Animation
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeAnimationUsing notification: Notification, for scene: DefaultScene) {
        if let animation = notification.object as? Animation {
            switch animation {
            case .move:
                controller.setupEditMoveAnimationNavigationItems()
                scene.isSelectingAnimationTargetLocation = true
                
                controller.presentedViewController?.dismiss(animated: true, completion: nil)
                
            case .rotate:
                let rotateAnimationAttributesView = Presenter.inject(.rotateAnimationAttributes(attributes: RotateAnimationAttributes()))
                let navigationController = controller.presentedViewController as! UINavigationController
                
                navigationController.pushViewController(rotateAnimationAttributesView, animated: true)
                
            case .delay:
                let delayAnimationAttributesView = Presenter.inject(.delayAnimationAttributes(attributes: DelayAnimationAttributes()))
                let navigationController = controller.presentedViewController as! UINavigationController
                
                navigationController.pushViewController(delayAnimationAttributesView, animated: true)
                
            case .alert:
                let alertAnimationAttributesView = Presenter.inject(.alertAnimationAttributes(attributes: AlertAnimationAttributes()))
                let navigationController = controller.presentedViewController as! UINavigationController
                
                navigationController.pushViewController(alertAnimationAttributesView, animated: true)
                
            default:
                break
            }
        }
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapDoneEditingMoveAnimationButtonForScene scene: DefaultScene) {
        guard let position = scene.nodeSelected?.position else {
            return
        }
        
        let animation = MoveAnimationAttributes(duration: 2, targetLocation: position, animationIndex: nil)
        scene.addMoveAnimation(animation)
        
        scene.isSelectingAnimationTargetLocation = false
        scene.resetLastNodeSelected()
        
        controller.setupAnimationNavigationItems()
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapPlayAnimationButtonWith sender: UIBarButtonItem, for scene: DefaultScene) {
        scene.playAnimation()
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didAddAlertAnimation animation: AlertAnimationAttributes, for scene: DefaultScene, in sceneView: SCNView) {
        scene.addAlertAnimation(animation, on: sceneView)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditingAnimation sender: UIBarButtonItem, for scene: DefaultScene) {
        controller.setupDefaultNavigationItems()
    }
    
    // MARK: - Touches
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesMovedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        scene.move(targetNode: nodeSelected, in: sceneView)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        let nodeSelected = sceneView.hitTest(location, options: nil).first?.node
        scene.didSelectNode(nodeSelected)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension SceneEditorViewControllerDelegate: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
