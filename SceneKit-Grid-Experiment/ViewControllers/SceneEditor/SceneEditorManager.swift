//
//  SceneEditorManager.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit
import EasyTipView

protocol SceneEditorDocumentDelegate: class {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: DefaultScene)
}

final class SceneEditorManager: NSObject {
    
    // MARK: - Internal Properties
    
    private var tipView: EasyTipView?
    
    private var sceneEditorController: SceneEditorViewController?
    
    // MARK: - Setup
    
    init(controller: SceneEditorViewController) {
        sceneEditorController = controller
    }
    
    // MARK: - Presenting
    
    func sceneEditor(_ controller: SceneEditorViewController, didDisplaySceneActionsMenuWith sender: UILongPressGestureRecognizer, at sceneView: SCNView) {
        tipView?.dismiss()
        
        let location = sender.location(in: controller.view)
        
        var sceneActionMenuController: UIViewController
        
        if let nodeSelected = sceneView.hitTest(location, options: nil).first?.node,
              nodeSelected.name == "floorNode" {
            sceneActionMenuController = Presenter.inject(.sceneActionsMenu(isNodeSelected: false))
        } else {
            sceneActionMenuController = Presenter.inject(.sceneActionsMenu(isNodeSelected: true))
            
            guard let controller = sceneActionMenuController as? SceneActionMenuViewController else {
                return
            }
            
            controller.delegate = self
        }
        
        sceneActionMenuController.modalPresentationStyle = .popover
        sceneActionMenuController.popoverPresentationController?.permittedArrowDirections = .down
        sceneActionMenuController.popoverPresentationController?.delegate = self
        
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
        
        sceneActionMenuController.popoverPresentationController?.sourceRect = sourceRect
        sceneActionMenuController.popoverPresentationController?.sourceView = touchView
        
        controller.present(sceneActionMenuController, animated: true) {
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
        
        guard let objectCatalogController = Presenter.inject(.objectCatalog) as? ObjectCatalogViewController else {
            return
        }
        
        objectCatalogController.delegate = self
        
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
            
            guard let nodeInspectorController = (viewController as? NodeInspectorViewController) else {
                return
            }
            
            nodeInspectorController.delegate = self
            
        } else {
            viewController = Presenter.inject(.sceneInspectorView)
            
            guard let sceneInspectorController = (viewController as? SceneInspectorViewController) else {
                return
            }
            
            sceneInspectorController.delegate = self
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
    
    func presentNodeAnimationList(with sender: UIBarButtonItem) {
        guard let nodeAnimationListController = Presenter.inject(.nodeAnimationList) as? NodeAnimationListViewController else {
            return
        }
        
        nodeAnimationListController.delegate = self

        let navigationController = UINavigationController()
        
        navigationController.viewControllers = [nodeAnimationListController]
        
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.popoverPresentationController?.delegate = self
        navigationController.popoverPresentationController?.barButtonItem = sender
        
        sceneEditorController?.present(navigationController, animated: true, completion: nil)
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
    
    private func didSelectSceneActionButton(_  button: UIButton, for scene: DefaultScene) {
        guard let action = button.titleLabel?.text else {
            return
        }
        
        switch action {
        case Action.animate.capitalized:
            sceneEditorController?.setupAnimationNavigationItems()
            scene.setNodeAnimationTarget()
            
        case Action.move.capitalized:
            sceneEditorController?.cameraNavigationPanGesture.isEnabled = false
            sceneEditorController?.setupEditNodePositionNavigationItems()
            
            scene.showGrid()
            scene.didSelectSceneAction(.move)
            
        case Action.pin.capitalized:
            sceneEditorController?.cameraNavigationPanGesture.isEnabled = true
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
        
        sceneEditorController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Color Picker
    
    func didModifyNodeColor(_ color: UIColor) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        scene.modifyNodeColor(to: color)
    }
    
    // MARK: - Object Catalog
    
    func didSelectNodeModel(_ nodeModel: NodeModel, for scene: DefaultScene) {
        sceneEditorController?.setupEditNodePositionNavigationItems()
        scene.showGrid()
        
        scene.insertNodeModel(nodeModel)
        sceneEditorController?.presentedViewController?.dismiss(animated: true, completion: nil)
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
    
    func didSelectNodeAnimation(animation: Animation, for scene: DefaultScene) {
        switch animation {
        case .move:
            sceneEditorController?.setupEditMoveAnimationNavigationItems()
            scene.showGrid()
            scene.isSelectingAnimationTargetLocation = true
            
            sceneEditorController?.presentedViewController?.dismiss(animated: true, completion: nil)
            
        case .rotate:
            let rotateAnimationAttributesView = Presenter.inject(.rotateAnimationAttributes(attributes: RotateAnimationAttributes()))
            let navigationController = sceneEditorController?.presentedViewController as! UINavigationController
            
            navigationController.pushViewController(rotateAnimationAttributesView, animated: true)
            
        case .delay:
            let delayAnimationAttributesView = Presenter.inject(.delayAnimationAttributes(attributes: DelayAnimationAttributes()))
            let navigationController = sceneEditorController?.presentedViewController as! UINavigationController
            
            navigationController.pushViewController(delayAnimationAttributesView, animated: true)
            
        case .speechBubble:
            let speechAnimationAnimationAttributesView = Presenter.inject(.speechBubbleAnimationAttributes(attributes: SpeechBubbleAnimationAttributes()))
            let navigationController = sceneEditorController?.presentedViewController as! UINavigationController
            
            navigationController.pushViewController(speechAnimationAnimationAttributesView, animated: true)
            
        default:
            break
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
        calculateNodeTransformation(using: touches)
    }
    
    private func calculateNodeTransformation(using touches: Set<UITouch>) {
        guard let controller = sceneEditorController else {
            // TODO: Error handle
            return
        }
        
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: controller.view)
        
        let zProjectedPoint: CGFloat = CGFloat(controller.sceneView.projectPoint(State.nodeSelected?.position ?? SCNVector3Zero).z)
        let locationVector: SCNVector3 = SCNVector3(location.x, location.y, zProjectedPoint)
        let unprojectedLocation = controller.sceneView.unprojectPoint(locationVector)
        
        guard let nodeSelected = controller.sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        if nodeSelected == State.nodeSelected {
            controller.cameraNavigationPanGesture.isEnabled = false
        }
        
        controller.document?.scene.moveNodeTo(unprojectedLocation, in: controller.sceneView)
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

extension SceneEditorManager: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let rootNavigationController = popoverPresentationController.presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        
        sceneEditorViewController.displayPressLongGestureTipView()
    }
}

// MARK: - SceneActionsMenuViewDelegate

extension SceneEditorManager: SceneActionMenuDelegate {
    func sceneActionMenu(_ sceneActionMenu: SceneActionMenuViewController, didSelectSceneActionButton button: UIButton) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        didSelectSceneActionButton(button, for: scene)
    }
}

// MARK: - NodeInspectorDelegate

extension SceneEditorManager: NodeInspectorDelegate {
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdateNodePosition position: SCNVector3) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        scene.changeNodePosition(to: position)
    }
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didAngleNodePosition angle: Float) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        scene.changeNodeRotation(toAngle: angle)
    }
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdatePlaneWidth width: CGFloat) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        scene.modifyPlaneNode(width: width)
    }
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdatePlaneLength length: CGFloat) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        scene.modifyPlaneNode(length: length)
    }
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdateNodeColor color: UIColor) {
        colorPicker(didSelectColor: color)
    }
}

// MARK: - AttributesInspectorDelegate

extension SceneEditorManager: SceneInspectorDelegate {
    func colorPicker(didSelectColor color: UIColor) {
        didModifyNodeColor(color)
    }
}

// MARK: - SceneActionsMenuViewDelegate

extension SceneEditorManager: ObjectCatalogDelegate {
    func objectCatalog(didSelectModel model: NodeModel) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        didSelectNodeModel(model, for: scene)
    }
}

// MARK: - NodeAnimationListDelegate

extension SceneEditorManager: NodeAnimationListDelegate {
    func nodeAnimationList(_ nodeAnimationList: NodeAnimationListViewController, didAddNodeAnimation animation: Animation) {
        guard let scene = sceneEditorController?.document?.scene else {
            // TODO: Error handle
            return
        }
        
        didSelectNodeAnimation(animation: animation, for: scene)
    }
}

// MARK: - EasyTipViewDelegate

extension SceneEditorManager: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        
    }
}
