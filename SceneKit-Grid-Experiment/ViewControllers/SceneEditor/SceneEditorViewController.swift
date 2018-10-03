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
    
    private var mainScene: DefaultScene = {
        let scene = DefaultScene()
        State.currentScene = Scene(scene: scene)
        return scene
    }()
    
    private lazy var delegate = SceneEditorViewControllerDelegate()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.allowsCameraControl = false
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = "Blank"
        sceneView.scene = mainScene
        
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
        
        navigationItem.setRightBarButtonItems([utilitiesInspectorBarButton, objectCatalogBarButton, nodeInspectorBarButton, playBarButton], animated: true)
    }
    
    private func setupNotificationListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(didModifyNodeColor(_:)), name: Notification.Name.ColorPickerDidModifyNodeColor, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectSceneAction(_:)), name: Notification.Name.SceneActionMenuDidSelectButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectNodeModel(_:)), name: Notification.Name.ObjectCatalogDidSelectNodeModel, object: nil)
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Color Picker
    
    @objc
    private func didModifyNodeColor(_ notification: Notification) {
        delegate.sceneEditor(self, didModifyNodeColorUsing: notification, for: mainScene)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate.sceneEditor(self, touchesBeganWith: touches, at: sceneView, for: mainScene)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        delegate.sceneEditor(self, touchesMovedWith: touches, at: sceneView, for: mainScene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate.sceneEditor(self, touchesEndedWith: touches, at: sceneView, for: mainScene)
    }
    
    @objc
    private func didTapObjectCatalogButton(_ sender: UIBarButtonItem) {
        delegate.sceneEditor(self, didDisplayObjectCatalogWith: sender)
    }
    
    @objc
    private func didTapNodeInspectorButton(_ sender: UIBarButtonItem) {
        delegate.sceneEditor(self, didDisplayInspectorViewWith: sender)
    }
    
    @objc
    private func didTapUtilitiesInspectorButton(_ sender: UIBarButtonItem) {
        delegate.sceneEditor(self, didDisplayUtilitiesInspectorWith: sender)
    }
    
    @objc
    private func didTapPlayButton(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        delegate.sceneEditor(self, didDisplaySceneActionsMenuWith: sender, at: sceneView)
    }
    
    @objc
    private func didSelectSceneAction(_ notification: Notification) {
        delegate.sceneEditor(self, didSelectSceneActionButtonUsing: notification, for: mainScene)
    }
    
    @objc
    private func didSelectNodeModel(_ notification: Notification) {
        delegate.sceneEditor(self, didSelectNodeModelUsing: notification, for: mainScene)
    }
    
    // MARK: - Device Configuration
    
    override var shouldAutorotate: Bool {
        return true
    }
    
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
