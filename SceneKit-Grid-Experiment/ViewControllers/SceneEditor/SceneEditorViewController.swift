//
//  SceneViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/04/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

enum SceneEditorState {
    case onboarding
    case editingNodePosition
    case editingNodeAnimation
    case normal
    case `default`
}

final class SceneEditorViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private(set) var state: SceneEditorState = .default
    
    private var browserTransition: DocumentBrowserTransitioningDelegate?
    
    // MARK: - Internal Properties
    
    var longPressGesture: UILongPressGestureRecognizer!
    var cameraNavigationPanGesture: UIPanGestureRecognizer!
    var cameraPanningPanGesture: UIPanGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    
    
    // MARK: - Normal Navigation Item Properties
    
    //////// ------- TODO: Move code to Main View ------- ////////
    private lazy var utilitiesInspectorBarButton: UIBarButtonItem = {
        let utilitiesInspectorButtonImage = UIImage(named: .utilitiesInspectorButton)
        let barButton = UIBarButtonItem(image: utilitiesInspectorButtonImage, style: .plain, target: self, action: #selector(didTapUtilitiesInspectorButton(_:)))
        return barButton
    }()
    
    private lazy var objectCatalogBarButton: UIBarButtonItem = {
        let objectCatalogButtonImage = UIImage(named: .objectCatalogButton)
        let barButton = UIBarButtonItem(image: objectCatalogButtonImage, style: .plain, target: self, action: #selector(didTapObjectCatalogButton(_:)))
        return barButton
    }()
    
    private lazy var nodeInspectorBarButton: UIBarButtonItem = {
        let nodeInspectorButtonImage = UIImage(named: .nodeInspectorButton)
        let barButton = UIBarButtonItem(image: nodeInspectorButtonImage, style: .plain, target: self, action: #selector(didTapNodeInspectorButton(_:)))
        return barButton
    }()
    
    private lazy var playBarButton: UIBarButtonItem = {
        let playButtonImage = UIImage(named: .playButton)
        let barButton = UIBarButtonItem(image: playButtonImage, style: .plain, target: self, action: #selector(didTapPlayButton(_:)))
        return barButton
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Projects", style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        return barButton
    }()
    
    // MARK: - Edit Move Navigation Item Properties
    
    private lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneEditingMoveAnimationButton(_:)))
        return barButton
    }()
    
    private lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelEditingMoveAnimationButton(_:)))
        return barButton
    }()
    //////// ------- ------------------------ ------- ////////
    
    
    // MARK: - Public Properties
    
    lazy var manager = SceneEditorManager(controller: self)
    
    public var sceneView: SCNView = {
        let sceneView = SCNView()
        
        #if !targetEnvironment(simulator) // CAMetalLayer does not compile when using simulator
            if let metalLayer = sceneView.layer as? CAMetalLayer {
                metalLayer.framebufferOnly = false
            }
        #endif
        
        sceneView.backgroundColor = .white
        sceneView.autoenablesDefaultLighting = true
        
        return sceneView
    }()
    
    public var document: SceneDocument?
    public var documentName: String = ""
    
    public weak var sceneEditorDelegate: SceneEditorDocumentDelegate?
    
    public var transitionController: UIDocumentBrowserTransitionController? {
        didSet {
            if let controller = transitionController {
                modalPresentationStyle = .custom
                browserTransition = DocumentBrowserTransitioningDelegate(withTransitionController: controller)
                transitioningDelegate = browserTransition
            } else {
                modalPresentationStyle = .none
                browserTransition = nil
                transitioningDelegate = nil
            }
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .onboarding
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let scene = document?.scene else {
            // TODO: Show error message
            return
        }
        
        sceneView.prepare([scene], completionHandler: { (success) in
            if success {
                self.sceneView.scene = scene
            }
        })
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupOnboarding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let scene = document?.scene else {
            fatalError("No document found.")
        }
        
        sceneEditorDelegate?.sceneEditor(self, didFinishEditing: scene)
    }
    
    // MARK: - Setup
    
    init(sceneDocument: SceneDocument, delegate: SceneEditorDocumentDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        document = sceneDocument
        document?.delegate = self
        
        sceneEditorDelegate = delegate
        
        documentName = sceneDocument.localizedName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        
        setupDefaultNavigationItems()
        setupLongPressGestureRecognizer()
        setupSceneViewGestures()
    }
    
    private func setupOnboarding() {
        switch state {
        case .onboarding:
            if UserDefaults.standard.bool(forKey: NotificationKey.hasDisplayedObjectCatalogTipView) {
                return
            }
            
            manager.sceneEditor(self, didDisplayOnboardingTipPopover: objectCatalogBarButton, message: "Tap this button to insert a 3D model fo your choice.")
            
            UserDefaults.standard.set(true, forKey: NotificationKey.hasDisplayedObjectCatalogTipView)

        default:
            break
        }
    }
    
    func setupDefaultNavigationItems() {
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
    
    // TODO: Reuse this when editing the position of the node
    func setupEditMoveAnimationNavigationItems() {
        title = "Select a point on the grid."
        
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButtonItems([doneBarButton], animated: true)
    }
    
    func setupEditNodePositionNavigationItems() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelEditingNodePositionButton(_:)))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didFinishEdittingNodePositionButton(_:)))
        
        title = "Drag the model to a point on the grid."
        
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButtonItems([doneBarButton], animated: true)
    }
    
    private func setupLongPressGestureRecognizer() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressSceneEditorView(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    private func setupSceneViewGestures() {
        cameraNavigationPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didBeginNavigatingCamera(_:)))
        cameraNavigationPanGesture.maximumNumberOfTouches = 1
        
        cameraPanningPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didBeginPanningCamera(_:)))
        cameraPanningPanGesture.minimumNumberOfTouches = 2
        
        sceneView.addGestureRecognizer(cameraNavigationPanGesture)
        sceneView.addGestureRecognizer(cameraPanningPanGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didBeginPinching(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, touchesBeganWith: touches, at: sceneView, for: scene)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, touchesMovedWith: touches, at: sceneView, for: scene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, touchesEndedWith: touches, at: sceneView, for: scene)
    }
    
    @objc
    private func didBeginNavigatingCamera(_ gesture: UIPanGestureRecognizer) {
        document?.scene.limitCameraRotation(using: gesture)
    }
    
    @objc
    private func didBeginPanningCamera(_ gesture: UIPanGestureRecognizer) {
        document?.scene.didPanCamera(using: gesture)
    }
    
    @objc
    private func didBeginPinching(_ gesture: UIPinchGestureRecognizer) {
        document?.scene.didAdjustCameraZoom(using: gesture)
    }
    
    @objc
    private func didTapObjectCatalogButton(_ sender: UIBarButtonItem) {
        manager.sceneEditor(self, didDisplayObjectCatalogWith: sender)
    }
    
    @objc
    private func didTapNodeInspectorButton(_ sender: UIBarButtonItem) {
        manager.sceneEditor(self, didDisplayInspectorViewWith: sender)
    }
    
    @objc
    private func didTapUtilitiesInspectorButton(_ sender: UIBarButtonItem) {
        manager.sceneEditor(self, didDisplayUtilitiesInspectorWith: sender)
    }
    
    @objc
    private func didTapPlayButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, didDisplayPresentationViewWith: scene, using: sender)
    }
    
    @objc
    private func didTapBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapAnimationCatalogButton(_ sender: UIBarButtonItem) {
        manager.presentNodeAnimationList(with: sender)
    }

    @objc
    private func didTapUndoAnimationButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func didTapPlayAnimationButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, didTapPlayAnimationButtonWith: sender, for: scene)
    }
    
    @objc
    private func didTapCancelEditingMoveAnimationButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        state = .normal
        
        scene.hideGrid()
        
        setupAnimationNavigationItems()
    }
    
    @objc
    private func didTapCancelEditingNodePositionButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        state = .normal
        
        manager.sceneEditor(self, didTapCancelEditingNodePositionButton: scene)
    }
    
    @objc
    private func didFinishEdittingNodePositionButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        state = .normal
        
        manager.sceneEditor(self, didFinishEditingNodePositionButton: scene)
        
        if UserDefaults.standard.bool(forKey: NotificationKey.hasDisplayedTap3DModelTipView) {
            return
        }
        
        manager.sceneEditor(self, didDisplayOnboardingTipPopoverFrom: view, message: "Tap the 3D model to select it.")
        
        UserDefaults.standard.set(true, forKey: NotificationKey.hasDisplayedTap3DModelTipView)
    }
    
    @objc
    private func didTapDoneEditingMoveAnimationButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        state = .editingNodeAnimation
        
        manager.sceneEditor(self, didTapDoneEditingMoveAnimationButtonForScene: scene)
    }
    
    @objc
    private func didTapDoneAnimatingButton(_ sender: UIBarButtonItem) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        state = .normal
        
        manager.sceneEditor(self, didFinishEditingAnimation: sender, for: scene)
    }
    
    @objc
    private func didLongPressSceneEditorView(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            manager.sceneEditor(self, didDisplaySceneActionsMenuWith: sender, at: sceneView)
            
        default:
            break
        }
    }
    
    // MARK: - External Properties
    
    func didTapAddSpeechBubbleAnimationButton(_ sender: UIButton, animation: SpeechBubbleAnimationAttributes) {
        guard let scene = document?.scene else {
            fatalError("No scene found.")
        }
        
        manager.sceneEditor(self, didAddSpeechBubbleAnimation: animation, for: scene, in: sceneView)
    }
    
    func displayObjectAttributesTipView() {
        if UserDefaults.standard.bool(forKey: NotificationKey.hasDisplayedObjectAttributesTipView) {
            return
        }
        
        manager.sceneEditor(self, didDisplayOnboardingTipPopover: nodeInspectorBarButton, message: "Tap this button to to modify the 3D model's properties.")
        
        UserDefaults.standard.set(true, forKey: NotificationKey.hasDisplayedObjectAttributesTipView)
    }
    
    func displayPressLongGestureTipView() {
        if UserDefaults.standard.bool(forKey: NotificationKey.hasDisplayedLongPressGestureTipView) {
            return
        }
        
        manager.sceneEditor(self, didDisplayOnboardingTipPopoverFrom: view, message: "Long press the 3D model to display a list of actions.")
        
        UserDefaults.standard.set(true, forKey: NotificationKey.hasDisplayedLongPressGestureTipView)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // TODO: Switch to iPad for production
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}

// MARK: - SceneDocumentDelegate

extension SceneEditorViewController: SceneDocumentDelegate {
    func sceneDocumentUpdateContent(_ document: SceneDocument) {
        sceneView.scene = document.scene
    }
    
    func sceneDocumentTransferBegan(_ document: SceneDocument) {}
    
    func sceneDocumentTransferEnded(_ document: SceneDocument) {}
    
    func sceneDocumentSaveFailed(_ document: SceneDocument) {
        let alert = UIAlertController(title: "Save Error", message: "An attempt to save the document failed.", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Device Rotation

extension SceneEditorViewController {
    
    // TODO: Fix positioning of the tip view when rotated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        view.layoutIfNeeded()
    }
    
}
