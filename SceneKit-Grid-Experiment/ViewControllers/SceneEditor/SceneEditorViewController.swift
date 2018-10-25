//
//  SceneViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/04/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class SceneEditorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private var sceneView: SCNView = {
        let sceneView = SCNView()
        sceneView.backgroundColor = .white
        return sceneView
    }()
    
    private lazy var viewControllerDelegate: SceneEditorViewControllerDelegateProtocol = SceneEditorViewControllerDelegate()
    
    // MARK: - Public Properties
    
    public var currentScene: DefaultScene {
        didSet {
            sceneEditorDelegate?.sceneEditor(self, didUpdateSceneContent: currentScene)
        }
    }
    
    public var documentName: String = ""
    
    public weak var sceneEditorDelegate: SceneEditorDocumentDelegate?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TODO: Reset the current node highlighted and selected
        sceneEditorDelegate?.sceneEditor(self, didUpdateSceneContent: currentScene)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    init(sceneDocument: SceneDocument, delegate: SceneEditorDocumentDelegate) {
        currentScene = sceneDocument.scene
        sceneEditorDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        documentName = sceneDocument.localizedName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        sceneView.scene = currentScene
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        
        // TODO: Place this inside SceneView
        sceneView.autoenablesDefaultLighting = true
        
        setupDefaultNavigationItems()
        setupLongPressGestureRecognizer()
        setupNotificationListeners()
        setupSceneViewGestures()
    }
    
    func setupDefaultNavigationItems() {
        let utilitiesInspectorButtonImage = UIImage(named: .utilitiesInspectorButton)
        let utilitiesInspectorBarButton = UIBarButtonItem(image: utilitiesInspectorButtonImage, style: .plain, target: self, action: #selector(didTapUtilitiesInspectorButton(_:)))
        
        let objectCatalogButtonImage = UIImage(named: .objectCatalogButton)
        let objectCatalogBarButton = UIBarButtonItem(image: objectCatalogButtonImage, style: .plain, target: self, action: #selector(didTapObjectCatalogButton(_:)))
        
        let nodeInspectorButtonImage = UIImage(named: .nodeInspectorButton)
        let nodeInspectorBarButton = UIBarButtonItem(image: nodeInspectorButtonImage, style: .plain, target: self, action: #selector(didTapNodeInspectorButton(_:)))
        
        let playButtonImage = UIImage(named: .playButton)
        let playBarButton = UIBarButtonItem(image: playButtonImage, style: .plain, target: self, action: #selector(didTapPlayButton(_:)))
        
        let backBarButton = UIBarButtonItem(title: "Projects", style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        
        title = documentName
        
        navigationController?.navigationBar.tintColor = .lavender
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        
        navigationItem.setLeftBarButton(backBarButton, animated: true)
        navigationItem.setRightBarButtonItems([utilitiesInspectorBarButton, objectCatalogBarButton, nodeInspectorBarButton, playBarButton], animated: true)
    }
    
    func setupAnimationNavigationItems() {
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneAnimatingButton(_:)))
        
        let animationCatalogButtonImage = UIImage(named: .objectCatalogButton)
        let animationCatalogBarButton = UIBarButtonItem(image: animationCatalogButtonImage, style: .plain, target: self, action: #selector(didTapAnimationCatalogButton(_:)))
        
        let undoButtonImage = UIImage(named: .undoButton)
        let undoBarButton = UIBarButtonItem(image: undoButtonImage, style: .plain, target: self, action: #selector(didTapUndoAnimationButton(_:)))
    
        let playButtonImage = UIImage(named: .playButton)
        let playBarButton = UIBarButtonItem(image: playButtonImage, style: .plain, target: self, action: #selector(didTapPlayAnimationButton(_:)))
        
        title = "Tap the add button to select an animation."
        
        navigationController?.navigationBar.barTintColor = .utilityBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.setLeftBarButton(undoBarButton, animated: true)
        navigationItem.setRightBarButtonItems([doneBarButton, animationCatalogBarButton, playBarButton], animated: true)
    }
    
    func setupEditMoveAnimationNavigationItems() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelEditingMoveAnimationButton(_:)))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneEditingMoveAnimationButton(_:)))
        
        title = "Select a point on the grid."
        
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButtonItems([doneBarButton], animated: true)
    }
    
    private func setupNotificationListeners() {
        // TODO: Refactor code to remove notifications and use dependencies instead
        NotificationCenter.default.addObserver(self, selector: #selector(didModifyNodeColor(_:)), name: Notification.Name.ColorPickerDidModifyNodeColor, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectSceneActionButton(_:)), name: Notification.Name.SceneActionMenuDidSelectButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectNodeModel(_:)), name: Notification.Name.ObjectCatalogDidSelectNodeModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectNodeAnimation(_:)), name: Notification.Name.NodeAnimationMenuDidSelectAnimation, object: nil)
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressSceneEditorView(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    private func setupSceneViewGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didBeginPanning(_:)))
        sceneView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didBeginPinching(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Color Picker
    
    @objc
    private func didModifyNodeColor(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didModifyNodeColorUsing: notification, for: currentScene)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewControllerDelegate.sceneEditor(self, touchesBeganWith: touches, at: sceneView, for: currentScene)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        viewControllerDelegate.sceneEditor(self, touchesMovedWith: touches, at: sceneView, for: currentScene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        viewControllerDelegate.sceneEditor(self, touchesEndedWith: touches, at: sceneView, for: currentScene)
    }
    
    @objc
    private func didBeginPanning(_ gesture: UIPanGestureRecognizer) {
        currentScene.limitCameraRotation(using: gesture)
    }
    
    @objc
    private func didBeginPinching(_ gesture: UIPinchGestureRecognizer) {
        currentScene.adjustCameraZoom(using: gesture)
    }
    
    @objc
    private func didTapObjectCatalogButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didDisplayObjectCatalogWith: sender)
    }
    
    @objc
    private func didTapNodeInspectorButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didDisplayInspectorViewWith: sender)
    }
    
    @objc
    private func didTapUtilitiesInspectorButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didDisplayUtilitiesInspectorWith: sender)
    }
    
    @objc
    private func didTapPlayButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didDisplayPresentationViewWith: currentScene, using: sender)
    }
    
    @objc
    private func didTapBackButton(_ sender: UIBarButtonItem) {
        sceneEditorDelegate?.sceneEditor(self, didFinishEditing: currentScene)
    }
    
    @objc
    private func didTapAnimationCatalogButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didDisplayNodeAnimationListWith: sender)
    }

    @objc
    private func didTapUndoAnimationButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func didTapPlayAnimationButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didTapPlayAnimationButtonWith: sender, for: currentScene)
    }
    
    @objc
    private func didTapCancelEditingMoveAnimationButton(_ sender: UIBarButtonItem) {
        setupAnimationNavigationItems()
    }
    
    @objc
    private func didTapDoneEditingMoveAnimationButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didTapDoneEditingMoveAnimationButtonForScene: currentScene)
    }
    
    @objc
    private func didTapDoneAnimatingButton(_ sender: UIBarButtonItem) {
        viewControllerDelegate.sceneEditor(self, didFinishEditingAnimation: sender, for: currentScene)
    }
    
    @objc
    private func didSelectSceneActionButton(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didSelectSceneActionButtonUsing: notification, for: currentScene)
    }
    
    @objc
    private func didSelectNodeModel(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didSelectNodeModelUsing: notification, for: currentScene)
    }
    
    @objc
    private func didSelectNodeAnimation(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didSelectNodeAnimationUsing: notification, for: currentScene)
    }

    @objc
    private func didLongPressSceneEditorView(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            viewControllerDelegate.sceneEditor(self, didDisplaySceneActionsMenuWith: sender, at: sceneView)
        default:
            break
        }
    }
    
    // MARK: - External Properties
    
    func didTapAddAlertAnimationButton(_ sender: UIButton, animation: AlertAnimationAttributes) {
        viewControllerDelegate.sceneEditor(self, didAddAlertAnimation: animation, for: currentScene, in: sceneView)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
