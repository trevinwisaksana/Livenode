//
//  PresentationViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

class PresentationViewControllerDelegate: NSObject {
    
    // MARK: - Node Presentation
    
    func addPresentingNode(to sceneView: ARSCNView, using scene: DefaultScene, at location: simd_float4) {
        let x = location.x
        let y = location.y
        let z = location.z
        
        let presentationNodes = SCNNode()
        guard let presentationNodeContainer = scene.rootNode.childNode(withName: "presentationNodeContainer", recursively: true) else {
            fatalError("Presentation node container cannot be found.")
        }
        
        presentationNodeContainer.childNodes.forEach { (node) in
            presentationNodes.addChildNode(node)
        }
        
        presentationNodes.position = SCNVector3(x, y, z)
        presentationNodes.scale = SCNVector3(0.02, 0.02, 0.02)
        sceneView.scene.rootNode.addChildNode(presentationNodes)

        presentationNodes.childNodes.forEach { (node) in
            let sequence = SCNAction.sequence(node.actions)
            node.runAction(sequence)
        }
    }
    
}
