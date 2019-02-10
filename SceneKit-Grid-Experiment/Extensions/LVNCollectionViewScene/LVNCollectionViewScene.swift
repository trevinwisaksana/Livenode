//
//  LVNCollectionView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/02/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol LVNCollectionViewSceneDelegate: class {
   
}

open class LVNCollectionViewScene: SCNScene {
    
    // MARK: - Properties
    
    weak var delegate: LVNCollectionViewSceneDelegate?
    
    /// A container that will be used to move all the child nodes up/down when scrolling.
    private var parentNode = LVNCollectionViewParentNode()
    private var previousParentNodeLocation = CGPoint(x: 0, y: 0)
    
    private var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.usesOrthographicProjection = true
        node.position.z = 6.0
        node.scale = SCNVector3(x: 3.2, y: 3.2, z: 3.2)
        
        node.light = SCNLight()
        node.light?.type = SCNLight.LightType.omni
        node.light?.intensity = 2000
        node.light?.spotInnerAngle = 90.0
        node.light?.attenuationStartDistance = 2.0
        node.light?.attenuationFalloffExponent = 5.0
        node.light?.attenuationEndDistance = 30.0
        
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
    }
   
}

// MARK: - Parent Node Translation

extension LVNCollectionViewScene {
    func parentNodeTranslate(using sender: UIPanGestureRecognizer, in view: UIView) {
        let translation = sender.translation(in: view)
        
        if sender.state == .changed {
            parentNode.position.y = -Float(translation.y * 0.02)
        }
    }
}
