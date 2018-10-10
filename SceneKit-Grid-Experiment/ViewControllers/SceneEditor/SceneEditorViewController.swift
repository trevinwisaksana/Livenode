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
        return sceneView
    }()
    
    private lazy var viewControllerDelegate = SceneEditorViewControllerDelegate()
    
    // MARK: - Public Properties
    
    public var currentScene: DefaultScene {
        didSet {
            sceneEditorDelegate?.sceneEditor(self, didUpdateSceneContent: currentScene)
        }
    }
    
    public weak var sceneEditorDelegate: SceneEditorDelegate?
    
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
    }
    
    // MARK: - Setup
    
    init(sceneDocument: SceneDocument, delegate: SceneEditorDelegate) {
        currentScene = sceneDocument.scene
        sceneEditorDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        title = sceneDocument.localizedName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        sceneView.scene = currentScene
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        
        // TODO: Place this inside SceneView
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        
        setupNavigationItems()
        setupLongPressGestureRecognizer()
        setupNotificationListeners()
    }
    
    private func setupNavigationItems() {
        let utilitiesInspectorButtonImage = UIImage(named: .utilitiesInspectorButton)
        let utilitiesInspectorBarButton = UIBarButtonItem(image: utilitiesInspectorButtonImage, style: .plain, target: self, action: #selector(didTapUtilitiesInspectorButton(_:)))
        
        let objectCatalogButtonImage = UIImage(named: .objectCatalogButton)
        let objectCatalogBarButton = UIBarButtonItem(image: objectCatalogButtonImage, style: .plain, target: self, action: #selector(didTapObjectCatalogButton(_:)))
        
        let nodeInspectorButtonImage = UIImage(named: .nodeInspectorButton)
        let nodeInspectorBarButton = UIBarButtonItem(image: nodeInspectorButtonImage, style: .plain, target: self, action: #selector(didTapNodeInspectorButton(_:)))
        
        let playButtonImage = UIImage(named: .playButton)
        let playBarButton = UIBarButtonItem(image: playButtonImage, style: .plain, target: self, action: #selector(didTapPlayButton(_:)))
        
        let backBarButton = UIBarButtonItem(title: "Scenes", style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        
        navigationItem.setLeftBarButton(backBarButton, animated: true)
        navigationItem.setRightBarButtonItems([utilitiesInspectorBarButton, objectCatalogBarButton, nodeInspectorBarButton, playBarButton], animated: true)
    }
    
    private func setupNotificationListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(didModifyNodeColor(_:)), name: Notification.Name.ColorPickerDidModifyNodeColor, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapSceneActionButton(_:)), name: Notification.Name.SceneActionMenuDidSelectButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectNodeModel(_:)), name: Notification.Name.ObjectCatalogDidSelectNodeModel, object: nil)
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
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
        viewControllerDelegate.sceneEditor(self, didDisplayPresentationViewWith: sender)
    }
    
    @objc
    private func didTapBackButton(_ sender: UIBarButtonItem) {
        sceneEditorDelegate?.sceneEditor(self, didFinishEditing: currentScene)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        viewControllerDelegate.sceneEditor(self, didDisplaySceneActionsMenuWith: sender, at: sceneView)
    }
    
    @objc
    private func didTapSceneActionButton(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didSelectSceneActionButtonUsing: notification, for: currentScene)
    }
    
    @objc
    private func didSelectNodeModel(_ notification: Notification) {
        viewControllerDelegate.sceneEditor(self, didSelectNodeModelUsing: notification, for: currentScene)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    
}
