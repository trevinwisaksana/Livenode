//
//  PresentationViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

class PresentationViewControllerDelegate: NSObject, ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    // MARK: - Node Presentation
    
    func addPresentingNode(to sceneView: ARSCNView, using scene: DefaultScene?, at location: simd_float4) {
        let x = location.x
        let y = location.y
        let z = location.z
        
        guard let scene = scene,
              let presentationNodes = scene.rootNode.childNode(withName: "presentationNodeContainer", recursively: true)
        else {
            // TODO: Fix issue which deletes the nodes when retrieving it from the rootNode
            print("Cannot find the presentation node container.")
            return
        }
        
        presentationNodes.position = SCNVector3(x, y, z)
        presentationNodes.scale = SCNVector3(0.02, 0.02, 0.02)
        
        sceneView.scene.rootNode.addChildNode(presentationNodes)
    }
    
}
