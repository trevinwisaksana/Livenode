//
//  SceneViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/04/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class SceneViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private var sceneView: SCNView!
    private var mainScene: GridScene! {
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
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var objectAttributeButton: UIBarButtonItem!
    
    
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
        mainScene = GridScene()
        
        sceneView = self.view as? SCNView
        sceneView.scene = mainScene
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .milk
    }
    
    private func setupNodeSelectedListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(didModifyNodeColor(_:)), name: Constants.NotificationCenter.nodeColorModifiedKey, object: nil)
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
    
    // MARK: - IBActions
    
    @IBAction func didTapAddObjectButton(_ sender: UIBarButtonItem) {
        presentObjectCatalogController(using: sender)
    }
    
    @IBAction func didTapObjectAttributeButton(_ sender: UIBarButtonItem) {
        presentInspectorViews(using: sender)
    }
    
    @IBAction func didTapUtilitiesButton(_ sender: UIBarButtonItem) {
        presentUtilitiesController(using: sender)
    }
    
    private func presentInspectorViews(using sender: UIBarButtonItem) {
        let navigationController = UINavigationController()
        let viewController: UIViewController
        
        if let _ = nodeSelected {
            viewController = Presenter.inject(.nodeInspectorView)
        } else {
            viewController = Presenter.inject(.sceneInspectorView)
        }
        
        navigationController.viewControllers = [viewController]
        
        navigationController.modalPresentationStyle = .popover
        
        navigationController.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.popoverPresentationController?.delegate = self
        navigationController.popoverPresentationController?.barButtonItem = sender
        
        present(navigationController, animated: true, completion: nil)
    }
    
    private func presentObjectCatalogController(using sender: UIBarButtonItem) {
        let objectCatalogController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: Constants.Controller.objectCatalog) as! ObjectCatalogViewController
        
        objectCatalogController.modalPresentationStyle = .popover
        
        objectCatalogController.popoverPresentationController?.permittedArrowDirections = .up
        objectCatalogController.popoverPresentationController?.delegate = self
        objectCatalogController.popoverPresentationController?.barButtonItem = sender
        
        objectCatalogController.delegate = self
        
        present(objectCatalogController, animated: true, completion: nil)
    }
    
    private func presentUtilitiesController(using sender: UIBarButtonItem) {
        let utilitiesController = Presenter.inject(.utilitiesView)
        
        utilitiesController.modalPresentationStyle = .popover
        
        utilitiesController.popoverPresentationController?.permittedArrowDirections = .up
        utilitiesController.popoverPresentationController?.delegate = self
        utilitiesController.popoverPresentationController?.barButtonItem = sender
        
        present(utilitiesController, animated: true, completion: nil)
    }
    
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        nodeSelected = sceneView.hitTest(location, options: nil).first?.node
        
        if nodeSelected?.name == "Floor" || nodeSelected == nil {
            unhighlight(lastNodeSelected)
            return
        }
        
        if nodeSelected?.name == "testNode" {
            didSelectTargetNode = true
            State.nodeSelected = Node(node: nodeSelected)
            highlight(nodeSelected)
        } else {
            didSelectTargetNode = false
        }
        
        lastNodeSelected = nodeSelected
    }
    
    // TODO: Find solution that doesn't only work with boxes
    private func highlight(_ nodeSelected: SCNNode?) {
        if didHighlightNode {
            return
        }
        
        guard let nodeSelected = nodeSelected else {
            return
        }
        
        // TODO: Make the dimensions the same with the node selected
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        let nodeHighlight = SCNNode(geometry: box)
        nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box_wireframe")
        nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        nodeHighlight.name = "nodeHighlight"
        
        nodeSelected.addChildNode(nodeHighlight)
        
        didHighlightNode = true
    }
    
    private func unhighlight(_ lastNodeSelected: SCNNode?) {
        didHighlightNode = false
        
        guard let node = lastNodeSelected else {
            return
        }
        
        let nodeHighlight = node.childNode(withName: "nodeHighlight", recursively: true)
        nodeHighlight?.removeFromParentNode()
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
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func didLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: view)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        if nodeSelected.name == "testNode" {
            showPopoverMenu(sender, for: nodeSelected)
        }
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

// MARK: - UIPopover

extension SceneViewController: UIPopoverPresentationControllerDelegate {
    
    func showPopoverMenu(_ sender: UILongPressGestureRecognizer, for node: SCNNode) {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "PopoverMenu") as! PopoverMenuViewController
        
        // set the selected node
        popController.viewModel.nodeSelected = node
        
        // set the presentation style
        popController.modalPresentationStyle = .popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = .down
        popController.popoverPresentationController?.delegate = self
        
        // set menu action delegate
        popController.menuAction = self
        
        let touchLocation = sender.location(in: view)
        let yOffset = view.frame.height * 0.05
        let sourceRect = CGRect(x: 0, y: yOffset, width: 1, height: 80)
        
        let touchView = UIView(frame: sourceRect)
        view.addSubview(touchView)
        
        touchView.backgroundColor = .clear
        touchView.center = touchLocation
        
        popController.popoverPresentationController?.sourceRect = sourceRect
        popController.popoverPresentationController?.sourceView = touchView
        
        // present the popover
        present(popController, animated: true) {
            touchView.removeFromSuperview()
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

// MARK: - Object Insertion Delegate

extension SceneViewController: ObjectInsertionDelegate {
    
    func insert3D(model: Model) {
        switch model {
        case .box:
            // TODO: Allow the object to be moved after inserted
            // TODO: Move the camera to the position of the new node
            mainScene.insertBox()
        case .pyramid:
            mainScene.insertPyramid()
        }
        
        mainScene.displayGrid()
    }
    
}

// MARK: - Move Object Delegate

extension SceneViewController: MenuActionDelegate {
    
    func move() {
        mainScene.displayGrid()
    }
    
    func delete() {
        
    }
    
    func copy() {
        
    }
    
    func paste() {
        
    }
    
}

