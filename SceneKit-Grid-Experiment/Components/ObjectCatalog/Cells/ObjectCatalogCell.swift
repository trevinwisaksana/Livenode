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
    
    @IBOutlet weak var objectSceneView: SCNView!
    
    func configure(with model: Model) {
        objectSceneView.scene = SCNScene(named: model.filename)
    }
    
}
