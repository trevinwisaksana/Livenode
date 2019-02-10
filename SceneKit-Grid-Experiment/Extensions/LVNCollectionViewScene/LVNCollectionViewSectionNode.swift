//
//  LVNCollectionViewSectionNode.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/02/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import SceneKit

open class LVNCollectionViewSectionNode: SCNNode {
    
    // MARK: - Node Insertion
    
    override func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach { (node) in
            
            arrange(nodeInGridFormation: node)
            
            addChildNode(node)
        }
    }
    
    // MARK: - Node Positioning
    
    /// Arranges the node into a grid or collection view style formation
    private func arrange(nodeInGridFormation node: SCNNode) {
        
    }
    
}
