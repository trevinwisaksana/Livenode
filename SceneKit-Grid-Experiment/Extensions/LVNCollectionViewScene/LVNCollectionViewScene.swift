//
//  LVNCollectionView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/02/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol LVNCollectionViewSceneProtocol: class {
   func lvnCollectionView(didSelectModelWith sender: UITapGestureRecognizer)
}

open class LVNCollectionViewScene: SCNScene {
    
    // MARK: - Properties
    
    /// A container that will be used to move all the child nodes up/down when scrolling.
    private var parentNode = LVNCollectionViewParentNode()
    
    private var previousParentNodeLocation = CGPoint(x: 0, y: 0)
    private var parentNodeVerticalLimit: Float = -100.0
    private var parentNodeOriginVerticalPosition: Float = 0.0
    private var totalTranslation: Float = 10
    
    private var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.usesOrthographicProjection = true
        node.position.z = 6.0
        node.scale = SCNVector3(x: 3.5, y: 3.5, z: 3.5)
        
        node.light = SCNLight()
        node.light?.color = UIColor.white
        node.light?.type = SCNLight.LightType.directional
        node.light?.intensity = 2500
        
        return node
    }()
    
    /// A list of nodes that will be presented on the collection view.
    private var nodeCells: [SCNNode] = [] {
        didSet {
            sections.first?.addChildNodes(nodeCells)
        }
    }
    
    /// A list of sections to divide the cell insertion. Is resposible for the cells arrangement. The default value is 1.
    private var sections = [LVNCollectionViewSectionNode()]
    
    // MARK: - Setup
    
    public init(nodesToPresent: [SCNNode]) {
        super.init()
        
        defer {
            nodeCells = nodesToPresent
        }
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        parentNode.addChildNodes(sections)
        rootNode.addChildNode(parentNode)
        rootNode.addChildNode(cameraNode)
        
        parentNodeOriginVerticalPosition = parentNode.position.y
    }
   
}

// MARK: - Parent Node Translation

extension LVNCollectionViewScene {
    func parentNodeTranslate(using sender: UIPanGestureRecognizer, in view: UIView) {
        var translation = sender.translation(in: view)
        let location = sender.location(in: view)
        
        switch sender.state {
        case .changed:
            translation.y = 2 * (location.y - previousParentNodeLocation.y)
            parentNode.position.y += Float(-translation.y * 0.02)
            
            if hasExceededVerticalLimit() {
                parentNode.position.y = parentNodeOriginVerticalPosition
            }
            
        default:
            break
            
        }
        
        previousParentNodeLocation.y = location.y
        
    }
    
    private func hasExceededVerticalLimit() -> Bool {
        return parentNode.position.y < parentNodeOriginVerticalPosition
    }
}
