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
    
    // MARK: - Properties
    
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
        
        setupGameView()
        setupLongPressGestureRecognizer()
        setupNavigationBar()
        setupNodeSelectedListener()
    }
    
    // MARK: - Setup
    
    private func setupGameView() {
        // create a new scene
        mainScene = GridScene()
        
        // retrieve the SCNView
        sceneView = self.view as! SCNView
        
        // set the scene to the view
        sceneView.scene = mainScene
        
        // allow camera control
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // default lighting
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
            mainScene.testNode.color = color
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
            nodeSelected = nil
            mainScene.testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            
            return
        }
        
        if nodeSelected?.name == "testNode" {
            didSelectTargetNode = true
            State.nodeSelected = Node(node: nodeSelected)
            
            let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
            let nodeHighlight = SCNNode(geometry: box)
            nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box_wireframe")
            nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
            nodeSelected?.addChildNode(nodeHighlight)
            
        } else {
            didSelectTargetNode = false
//            mainScene.testNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        
        if lastNodeSelected != nodeSelected {
            lastNodeSelected = nil
        }
        
        lastNodeSelected = nodeSelected
        
        // TESTING
        if let newNode = mainScene.rootNode.childNode(withName: "testNode", recursively: true) {
            sceneView.pointOfView?.pivot = newNode.pivot
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }

        if didSelectTargetNode {
//            gameView.allowsCameraControl = false
            
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
//
//        gameScene.testNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        // TODO: Create a Done button to finish moving
//        gameScene.testNode.isMovable = false
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
        
        mainScene.showGrid()
    }
    
}

// MARK: - Move Object Delegate

extension SceneViewController: MenuActionDelegate {
    
    func move() {
        mainScene.showGrid()
    }
    
    func delete() {
        
    }
    
    func copy() {
        
    }
    
    func paste() {
        
    }
    
}

