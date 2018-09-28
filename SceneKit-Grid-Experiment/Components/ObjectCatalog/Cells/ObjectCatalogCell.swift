//
//  ObjectCatalogCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 23/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class ObjectCatalogCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    private lazy var objectSceneView: SCNView = {
        let sceneView = SCNView(frame: .zero)
        return sceneView
    }()
    
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
        addSubview(objectSceneView)
        objectSceneView.fillInSuperview()
        objectSceneView.scene = SCNScene(named: "Box.scn")
    }
    
}
