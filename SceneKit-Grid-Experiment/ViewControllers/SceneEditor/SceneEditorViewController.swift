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
    
    private var sceneView: SCNView = SCNView()

    lazy var delegate: SceneEditorDelegateProtocol = SceneEditorViewControllerDelegate()
    
    private var mainScene: DefaultScene! {
        didSet {
            State.currentScene = Scene(scene: mainScene)
        }
    }
    
    private var nodeSelected: SCNNode?
    private var lastNodeSelected: SCNNode?
    private var lastNodePosition: SCNVector3?
    
    private var didSelectTargetNode = false
    private var didHighlightNode = false
    
    private var didFinishDraggingNode = false {
        didSet {
            sceneView.allowsCameraControl = true
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupScene()
        setupLongPressGestureRecognizer()
        setupNavigationBar()
        setupNodeSelectedListener()
    }
    
    private func setupScene() {
        mainScene = DefaultScene()
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        
        sceneView.scene = mainScene
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        setupNavigationBarButtons()
    }
    
    private func setupNavigationBarButtons() {
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
    
    private func setupNodeSelectedListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(didModifyNodeColor(_:)), name: Constants.NotificationCenter.nodeColorModifiedKey, object: nil)
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Node Selected
    
    @objc
    private func didModifyNodeColor(_ notification: Notification) {
        if let color = notification.object as? UIColor {
            guard let name = nodeSelected?.name else {
                return
            }
            
            let node = mainScene.rootNode.childNode(withName: name, recursively: true)
            node?.color = color
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        nodeSelected = sceneView.hitTest(location, options: nil).first?.node
        
        if nodeSelected?.name == "Floor" || nodeSelected == nil {
//            unhighlight(lastNodeSelected)
            return
        }
        
        if nodeSelected?.name == "testNode" {
            didSelectTargetNode = true
            State.nodeSelected = Node(node: nodeSelected)
//            highlight(nodeSelected)
        } else {
            didSelectTargetNode = false
        }
        
        lastNodeSelected = nodeSelected
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }

        if didSelectTargetNode {
            let nodeXPos = nodeSelected.position.x
            let nodeYPos = nodeSelected.position.y
            var nodeZPos = nodeSelected.position.z
            
            if nodeZPos >= 1 {
                nodeZPos = 0
            }
            
            if mainScene.testNode.isMovable {
                mainScene.testNode.position = SCNVector3(nodeXPos, nodeYPos, nodeZPos + 1)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didFinishDraggingNode = true
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
        let location = sender.location(in: view)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        if nodeSelected.name == "testNode" {
            delegate.sceneEditor(self, didDisplaySceneActionsMenuFor: nodeSelected, with: sender)
        }
    }
    
    // TODO: Move the node manipulation code elsewhere
    // TODO: Find solution that doesn't only work with boxes
//    private func highlight(_ nodeSelected: SCNNode?) {
//        if didHighlightNode {
//            return
//        }
//
//        guard let nodeSelected = nodeSelected else {
//            return
//        }
//
//        // TODO: Make the dimensions the same with the node selected
//        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
//
//        let nodeHighlight = SCNNode(geometry: box)
//        nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box_wireframe")
//        nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
//        nodeHighlight.name = "nodeHighlight"
//
//        nodeSelected.addChildNode(nodeHighlight)
//
//        didHighlightNode = true
//    }
//
//    private func unhighlight(_ lastNodeSelected: SCNNode?) {
//        didHighlightNode = false
//
//        guard let node = lastNodeSelected else {
//            return
//        }
//
//        let nodeHighlight = node.childNode(withName: "nodeHighlight", recursively: true)
//        nodeHighlight?.removeFromParentNode()
//    }
    
    
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
