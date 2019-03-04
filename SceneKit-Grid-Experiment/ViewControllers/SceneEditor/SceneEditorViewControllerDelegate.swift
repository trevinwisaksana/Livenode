//
//  SceneEditorDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit
import EasyTipView

protocol SceneEditorViewControllerDelegateProtocol: class {
    
    //
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayPresentationViewWith scene: DefaultScene, using sender: UIBarButtonItem)
    
    //
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayUtilitiesInspectorWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayObjectCatalogWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayNodeAnimationListWith sender: UIBarButtonItem)
    
    // Onboarding
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayOnboardingTipPopover sender: UIBarButtonItem, message: String)
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayOnboardingTipPopoverFrom view: UIView, message: String)
    
    //
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeAnimationUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didModifyNodeColorUsing notification: Notification, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeModelUsing notification: Notification, for scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapDoneEditingMoveAnimationButtonForScene scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didTapPlayAnimationButtonWith sender: UIBarButtonItem, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didTapCancelEditingNodePositionButton scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditingNodePositionButton scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditingAnimation sender: UIBarButtonItem, for scene: DefaultScene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didAddSpeechBubbleAnimation animation: SpeechBubbleAnimationAttributes, for scene: DefaultScene, in sceneView: SCNView)
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesMovedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene)
}

protocol SceneEditorDocumentDelegate: class {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: DefaultScene)
}

final class SceneEditorViewControllerDelegate: NSObject, SceneEditorViewControllerDelegateProtocol {
    
    // MARK: - Properties
    
    private var tipView: EasyTipView?
    
    // MARK: - Presenting
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView) {
        tipView?.dismiss()
        
        let location = sender.location(in: controller.view)
        
        var sceneActionsMenuController: UIViewController
        
        if let nodeSelected = sceneView.hitTest(location, options: nil).first?.node,
              nodeSelected.name == "floorNode" {
            sceneActionsMenuController = Presenter.inject(.sceneActionsMenu(isNodeSelected: false))
        } else {
            sceneActionsMenuController = Presenter.inject(.sceneActionsMenu(isNodeSelected: true))
        }
        
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
        tipView?.dismiss()
        
        let objectCatalogController = Presenter.inject(.objectCatalog)
        
        objectCatalogController.modalPresentationStyle = .popover
        objectCatalogController.popoverPresentationController?.permittedArrowDirections = .up
        objectCatalogController.popoverPresentationController?.delegate = self
        objectCatalogController.popoverPresentationController?.barButtonItem = sender
        
        controller.present(objectCatalogController, animated: true, completion: nil)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayInspectorViewWith sender: UIBarButtonItem) {
        tipView?.dismiss()
        
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
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayOnboardingTipPopover sender: UIBarButtonItem, message: String) {
        
        tipView = EasyTipView(text: message, preferences: EasyTipView.globalPreferences, delegate: self)
        tipView?.show(animated: true, forItem: sender, withinSuperView: nil)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplayOnboardingTipPopoverFrom view: UIView, message: String) {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
        
        let temporaryView = UIView(frame: frame)
        temporaryView.center.x = view.center.x
        temporaryView.center.y = view.center.y * 0.2
        
        controller.view.addSubview(temporaryView)
        
        tipView = EasyTipView(text: message, preferences: EasyTipView.toolTipPopupViewPreference(), delegate: self)
        tipView?.show(animated: true, forView: temporaryView, withinSuperview: nil)
    }

    // MARK: - Scene Action Menu
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectSceneActionButtonUsing notification: Notification, for scene: DefaultScene) {
        guard let action = notification.object as? String else {
            return
        }
        
        switch action {
        case Action.animate.capitalized:
            controller.setupAnimationNavigationItems()
            scene.setNodeAnimationTarget()
            
        case Action.move.capitalized:
            controller.cameraNavigationPanGesture.isEnabled = false
            controller.setupEditNodePositionNavigationItems()
            
            scene.showGrid()
            scene.didSelectSceneAction(.move)
            
        case Action.pin.capitalized:
            controller.cameraNavigationPanGesture.isEnabled = true
            scene.didSelectSceneAction(.pin)
            
        case Action.delete.capitalized:
            scene.didSelectSceneAction(.delete)
            
        case Action.copy.capitalized:
            scene.didSelectSceneAction(.copy)
            
        case Action.paste.capitalized:
            scene.didSelectSceneAction(.paste)
            
        case Action.cut.capitalized:
            scene.didSelectSceneAction(.cut)
            
        default:
            break
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
        
        controller.setupEditNodePositionNavigationItems()
        scene.showGrid()
        
        if let nodeModel = notification.object as? NodeModel {
            scene.insertNodeModel(nodeModel)
            controller.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Node Movement
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapCancelEditingNodePositionButton scene: DefaultScene) {
        
        controller.setupDefaultNavigationItems()
        controller.cameraNavigationPanGesture.isEnabled = true
        
        scene.hideGrid()
        
        scene.recentNodeAdded?.removeFromParentNode()
        scene.resetToOriginalNodeposition()
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditingNodePositionButton scene: DefaultScene) {
        
        controller.setupDefaultNavigationItems()
        controller.cameraNavigationPanGesture.isEnabled = true
        
        scene.hideGrid()
        scene.didSelectSceneAction(.pin)
    }
    
    // MARK: - Node Animation
    
    func sceneEditor(_ controller: SceneEditorViewController, didSelectNodeAnimationUsing notification: Notification, for scene: DefaultScene) {
        if let animation = notification.object as? Animation {
            switch animation {
            case .move:
                controller.setupEditMoveAnimationNavigationItems()
                scene.showGrid()
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
                
            case .speechBubble:
                let speechAnimationAnimationAttributesView = Presenter.inject(.speechBubbleAnimationAttributes(attributes: SpeechBubbleAnimationAttributes()))
                let navigationController = controller.presentedViewController as! UINavigationController
                
                navigationController.pushViewController(speechAnimationAnimationAttributesView, animated: true)
                
            default:
                break
            }
        }
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapDoneEditingMoveAnimationButtonForScene scene: DefaultScene) {
        // TODO: Node selected can only be floor nodes
        guard let nodeSelected = scene.nodeSelected, nodeSelected.name == Constants.Node.tileBorder else {
            return
        }
        
        let animation = MoveAnimationAttributes(duration: 2, targetLocation: nodeSelected.position, animationIndex: nil)
        scene.addMoveAnimation(animation)
        
        scene.isSelectingAnimationTargetLocation = false
        scene.hideGrid()
        scene.resetLastNodeSelected()
        
        controller.setupAnimationNavigationItems()
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didTapPlayAnimationButtonWith sender: UIBarButtonItem, for scene: DefaultScene) {
        scene.playAnimation()
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didAddSpeechBubbleAnimation animation: SpeechBubbleAnimationAttributes, for scene: DefaultScene, in sceneView: SCNView) {
        scene.addSpeechBubbleAnimation(animation, on: sceneView)
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
        
        if nodeSelected == State.nodeSelected {
            controller.cameraNavigationPanGesture.isEnabled = false
        }
        
        scene.move(targetNode: nodeSelected, in: sceneView)
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesBeganWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        let nodeSelected = sceneView.hitTest(location, options: nil).first?.node
        scene.didSelectNode(nodeSelected)
        
        if scene.didSelectANode && controller.state == .normal {
            tipView?.dismiss()
            
            controller.displayObjectAttributesTipView()
        }
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, touchesEndedWith touches: Set<UITouch>, at sceneView: SCNView, for scene: DefaultScene) {
        controller.cameraNavigationPanGesture.isEnabled = true
    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension SceneEditorViewControllerDelegate: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let rootNavigationController = popoverPresentationController.presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        
        sceneEditorViewController.displayPressLongGestureTipView()
    }
}

// MARK: - EasyTipViewDelegate

extension SceneEditorViewControllerDelegate: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        
    }
}
