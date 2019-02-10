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
    func collectionViewScene(_ collectionViewScene: LVNCollectionViewScene, didSelectNode section: Int) -> Int
}

open class LVNCollectionViewScene: SCNScene {
    
    // MARK: - Properties
    
    weak var delegate: LVNCollectionViewSceneDelegate?
    
    /// A container that will be used to move all the child nodes up/down when scrolling.
    private var parentNode = LVNCollectionViewParentNode()
    
    /// A list of nodes that will be presented on the collection view.
    private var nodeCells: [LVNCollectionViewCellNode] = [] {
        didSet {
            sections.first?.addChildNodes(nodeCells)
        }
    }
    
    /// A list of sections to divide the cell insertion. Is resposible for the cells arrangement. The default value is 1.
    private var sections = [LVNCollectionViewSectionNode()]
    
    /// Pan gesture to detect scrolling.
    private var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didBeginScrolling(_:)))
        return gestureRecognizer
    }()
    
    
    // MARK: - Setup
    
    public init(nodesToPresent: [LVNCollectionViewCellNode]) {
        super.init()
        
        self.nodeCells = nodesToPresent
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        parentNode.addChildNodes(sections)
        rootNode.addChildNode(parentNode)
    }
    
    
    // MARK: - User Interaction
    
    @objc
    private func didBeginScrolling(_ sender: UIPanGestureRecognizer) {
        
    }
   
}
