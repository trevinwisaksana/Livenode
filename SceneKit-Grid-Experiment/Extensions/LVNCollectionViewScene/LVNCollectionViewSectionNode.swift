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
    
    open var numberOfColumns: Int = 3
    
    /// Counts how many elements in are in the section.
    private var index = 0 {
        didSet {
            nodeXPosition += 2.2
            
            if index != 0 && index % numberOfColumns == 0 {
                row += 1
                nodeXPosition = -2.0
            }
        }
    }
    
    /// Counts how many rows are in the section.
    private var row = 0 {
        didSet {
            nodeYPosition -= 2.0
        }
    }
    
    /// Sets the Y position of the nodes in each row.
    private var nodeYPosition: Float = 2.0
    
    /// Sets the X position of the nodes in each row.
    private var nodeXPosition: Float = -2.0
    
    
    // MARK: - Node Insertion
    
    override func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach { (node) in
            
            arrange(nodeInGridFormation: node)

            addChildNode(node)
            
            index += 1
        }
    }
    
    // MARK: - Node Positioning
    
    /// Arranges the node into a grid or collection view style formation
    private func arrange(nodeInGridFormation node: SCNNode) {
        node.position.x = nodeXPosition
        node.position.y = nodeYPosition
    }
    
}
