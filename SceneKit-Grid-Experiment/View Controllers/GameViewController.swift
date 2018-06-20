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
    
    //---- Properties ----//
    
    var gameView: SCNView!
    var gameScene: GridScene!
    var cameraNode: SCNNode!
    
    var nodeSelected: SCNNode?
    var lastNodeSelected: SCNNode?
    var lastNodePosition: SCNVector3?
    
    var didSelectTargetNode = false
    
    var didFinishDraggingNode = false {
        didSet {
            gameView.allowsCameraControl = true
        }
    }
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGameView()
        prepareLongPressGestureRecognizer()
    }
    
    //---- Setup ----//
    
    func setupGameView() {
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
    
    //---- Touches ----//
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first ?? UITouch()
        let location = touch.location(in: view)
        
        nodeSelected = gameView.hitTest(location, options: nil).first?.node
        
        if nodeSelected?.name == "testNode" {
            didSelectTargetNode = true
            nodeSelected?.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        } else {
            didSelectTargetNode = false
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
        didFinishDraggingNode = true
        
        gameScene.testNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.white
    }
    
    func prepareLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    func didLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: view)
        
        guard let nodeSelected = gameView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        if nodeSelected.name == "testNode" {
            showPopover(sender, for: nodeSelected)
        }
    }
    
    
    //–––– Device Configuration ––––//
    
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

extension GameViewController: UIPopoverPresentationControllerDelegate {
    
    //---- UIPopover ----//
    
    func showPopover(_ sender: UILongPressGestureRecognizer, for node: SCNNode) {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "PopoverMenu") as! PopoverMenuViewController
        
        // set the selected node
        popController.viewModel.selectedNode = node
        
        // set the presentation style
        popController.modalPresentationStyle = .popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = .up
        popController.popoverPresentationController?.delegate = self
        
        let touchLocation = sender.location(in: view)
        let yOffset = -view.frame.height * 0.05
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
