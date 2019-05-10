//
//  NodePresentationManager.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

final class NodePresentationManager: NSObject {
    
    // MARK: - Dependency Injection
    
    static var currentScene: DefaultScene? {
        didSet {
            guard let presentationNodeContainer = NodePresentationManager.currentScene?.rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
                fatalError("Presentation node container cannot be found.")
            }
            
            NodePresentationManager.presentationNodeContainer = presentationNodeContainer.clone()
        }
    }
    
    static var presentationNodeContainer: SCNNode?
    
    
    // MARK: - Node Presentation
    
    func addPresentingNode(to sceneView: ARSCNView, at location: simd_float4) {
        let x = location.x
        let y = location.y
        let z = location.z
        
        let presentationNodes = SCNNode()
        
        NodePresentationManager.presentationNodeContainer?.childNodes.forEach { (node) in
            let newNode = node.clone()
            newNode.actions = node.actions
            presentationNodes.addChildNode(newNode)
        }
        
        presentationNodes.position = SCNVector3(x, y, z)
        presentationNodes.scale = SCNVector3(0.02, 0.02, 0.02)
        sceneView.scene.rootNode.addChildNode(presentationNodes)

        presentationNodes.childNodes.forEach { (node) in
//            if node.willDisplaySpeechBubble {
//                let customAction = SCNAction.customAction(duration: 2.0) { (node, time) in
//                    let alertNode = node.childNode(withName: Constants.Node.speechBubble, recursively: true)
//                    alertNode?.runAction(action)
//                }
//
//                node.actions.append(customAction)
//            }
            
            let sequence = SCNAction.sequence(node.actions)
            node.runAction(sequence)
        }
    }
    
}
