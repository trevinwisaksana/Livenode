//
//  ObjectCatalogPresentableViewHelper.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public struct ObjectCatalogModel: ObjectCatalogViewModel {
    public var objectModelScene: SCNScene
}

public struct ObjectCatalogModelFactory {
    public static func create() -> [ObjectCatalogModel] {
        var objectCatalogModels: [ObjectCatalogModel] = []
        
        for objectModelIndex in 0...1 {
            guard let modelScene = SCNScene(named: filenames[objectModelIndex]) else {
                fatalError("Cannot load model scene.")
            }
            
            objectCatalogModels.append(ObjectCatalogModel(objectModelScene: modelScene))
        }
    
        return objectCatalogModels
    }
    
    private static var filenames: [String] {
        return [
            "Box.scn",
            "Pyramid.scn"
        ]
    }
}
