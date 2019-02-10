//
//  LVNCollectionViewSectionNode.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/02/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import SceneKit

open class LVNCollectionViewSectionNode: SCNNode {
    
    // MARK: - Internal Properties
    
    /// Counts how many elements in are in the section.
    private var index = 0 {
        didSet {
            if index != 0 && index % 2 == 0 {
                row += 1
            }
        }
    }
    
    /// Counts how many rows are in the section.
    private var row = 0 {
        didSet {
            nodeYPosition += 2.8
        }
    }
    
    /// Sets the Y position of the nodes in each row.
    private var nodeYPosition: Float = -1.5
    
    
    // MARK: - Node Insertion
    
    override func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach { (node) in
            
            arrange(nodeInGridFormation: node)
            rotate(node)

            addChildNode(node)
            
            index += 1
        }
    }
    
    // MARK: - Node Positioning
    
    /// Arranges the node into a grid or collection view style formation
    private func arrange(nodeInGridFormation node: SCNNode) {
        if index % 2 == 0 {
            node.position.x = -1.6
            
        } else {
            node.position.x = 1.6
            
        }
        
        node.position.y = nodeYPosition
    }
    
    private func rotate(_ node: SCNNode) {
        let rotateAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 8.0)
        let action = SCNAction.repeatForever(rotateAction)
        node.runAction(action)
    }
    
}
