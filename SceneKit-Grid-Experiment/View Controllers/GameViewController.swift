//
//  GameViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/04/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    private var gameView: SCNView!
    private var gameScene: GridScene!
    private var cameraNode: SCNNode!
    
    private var nodeSelected: SCNNode? {
        didSet {
            if nodeSelected == nil {
                objectAttributeButton.isEnabled = false
            } else {
                objectAttributeButton.isEnabled = true
            }
        }
    }
    
    private var lastNodeSelected: SCNNode?
    private var lastNodePosition: SCNVector3?
    
    private var didSelectTargetNode = false
    
    private var didFinishDraggingNode = false {
        didSet {
            gameView.allowsCameraControl = true
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var objectAttributeButton: UIBarButtonItem!
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGameView()
        prepareLongPressGestureRecognizer()
    }
    
    // MARK: - Setup
    
    private func setupGameView() {
        // create a new scene
        gameScene = GridScene()
        
        // retrieve the SCNView
        gameView = self.view as! SCNView
        
        // set the scene to the view
        gameView.scene = gameScene
        
        // allow camera control
        gameView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        gameView.showsStatistics = false
        
        // configure the view
        gameView.backgroundColor = .white
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapAddObjectButton(_ sender: UIBarButtonItem) {
        // get a reference to the view controller for the popover
        let objectCatalogController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: Constants.Controller.objectCatalog) as! ObjectCatalogViewController
        
        // set the presentation style
        objectCatalogController.modalPresentationStyle = .popover
        
        // set up the popover presentation controller
        objectCatalogController.popoverPresentationController?.permittedArrowDirections = .up
        objectCatalogController.popoverPresentationController?.delegate = self
        objectCatalogController.popoverPresentationController?.barButtonItem = sender
        
        // set delegate
        objectCatalogController.delegate = self
        
        // present the popover
        present(objectCatalogController, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapObjectAttributeButton(_ sender: UIBarButtonItem) {
        // get a reference to the view controller for the popover
        let objectAttributeController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: Constants.Controller.objectAttribute) as! ObjectAttributeViewController
        
        // set the selected node
        guard let nodeSelected = nodeSelected else {
            return
        }
        
        objectAttributeController.viewModel.nodeSelected = nodeSelected
        
        // set the presentation style
        objectAttributeController.modalPresentationStyle = .popover
        
        // set up the popover presentation controller
        objectAttributeController.popoverPresentationController?.permittedArrowDirections = .up
        objectAttributeController.popoverPresentationController?.delegate = self
        objectAttributeController.popoverPresentationController?.barButtonItem = sender
        
        // present the popover
        present(objectAttributeController, animated: true, completion: nil)
    }
    
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        nodeSelected = gameView.hitTest(location, options: nil).first?.node
        
        if nodeSelected?.name == "testNode" {
            didSelectTargetNode = true
            nodeSelected?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        } else {
            didSelectTargetNode = false
//            lastNodeSelected?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        
        if lastNodeSelected != nodeSelected {
            lastNodeSelected = nil
        }
        
        lastNodeSelected = nodeSelected
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        guard let nodeSelected = gameView.hitTest(location, options: nil).first?.node else {
            return
        }

        if didSelectTargetNode {
            gameView.allowsCameraControl = false
            
            let nodeXPos = nodeSelected.position.x
            let nodeYPos = nodeSelected.position.y
            var nodeZPos = nodeSelected.position.z
            
            if nodeZPos >= 1 {
                nodeZPos = 0
            }
            
            if gameScene.testNode.isMovable {
                gameScene.testNode.position = SCNVector3(nodeXPos, nodeYPos, nodeZPos + 1)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        didFinishDraggingNode = true
//
//        gameScene.testNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        // TODO: Create a Done button to finish moving
//        gameScene.testNode.isMovable = false
    }
    
    func prepareLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func didLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: view)
        
        guard let nodeSelected = gameView.hitTest(location, options: nil).first?.node else {
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

extension GameViewController: UIPopoverPresentationControllerDelegate {
    
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

extension GameViewController: ObjectInsertionDelegate {
    
    func insert3D(model: Model) {
        switch model {
        case .cube:
            // TODO: Allow the object to be moved after inserted
            gameScene.insertNode()
            gameScene.showGrid()
        }
    }
    
}

// MARK: - Move Object Delegate

extension GameViewController: MenuActionDelegate {
    
    func move() {
        gameScene.showGrid()
    }
    
    func delete() {
        
    }
    
    func copy() {
        
    }
    
    func paste() {
        
    }
    
}

