//
//  ObjectCatalogView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol ObjectCatalogViewDelegate: class {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectModel model: NodeModel)
}

public class ObjectCatalogView: UIView  {
    
    // MARK: - Internal properties
    
    lazy var sceneView: SCNView = {
        let sceneView = SCNView()
        
        #if !targetEnvironment(simulator) // CAMetalLayer does not compile when using simulator
            if let metalLayer = sceneView.layer as? CAMetalLayer {
                metalLayer.framebufferOnly = false
            }
        #endif
        
        sceneView.prepare([collectionViewScene], completionHandler: { (success) in
            if success {
                self.sceneView.scene = self.collectionViewScene
            }
        })
        
        return sceneView
    }()
    
    private lazy var collectionViewScene: LVNCollectionViewScene = {
        let scene = LVNCollectionViewScene(nodesToPresent: ObjectCatalogModelFactory.create())
        return scene
    }()
    
    weak var delegate: ObjectCatalogViewDelegate?
    
    // MARK: - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(sceneView)
        sceneView.fillInSuperview()
    }
    
}

// MARK: - User Interaction

extension ObjectCatalogView {
    @objc
    func didBeginScrolling(_ sender: UIPanGestureRecognizer, inView view: UIView) {
        collectionViewScene.parentNodeTranslate(using: sender, in: view)
    }
}

// MARK: - LVNCollectionViewSceneDelegate

extension ObjectCatalogView: LVNCollectionViewSceneProtocol {
    func didSelectModel(_ sender: UITapGestureRecognizer, withType type: NodeModel) {
        delegate?.objectCatalogView(self, didSelectModel: type)
    }
    
    public func lvnCollectionView(didSelectModelWith sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        guard let nodeSelected = sceneView.hitTest(location, options: nil).first?.node else {
            return
        }
        
        didSelectModel(sender, withType: nodeSelected.type)
    }
}
