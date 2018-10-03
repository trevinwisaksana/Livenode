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
    public var nodeModel: NodeModel
}

public struct ObjectCatalogModelFactory {
    public static func create() -> [ObjectCatalogModel] {
        var objectCatalogModels: [ObjectCatalogModel] = []
        
        for objectModelIndex in 0...1 {
            guard let modelScene = SCNScene(named: filenames[objectModelIndex]) else {
                fatalError("Cannot load model scene.")
            }
            
            let nodeModel = nodeModels[objectModelIndex]
            
            objectCatalogModels.append(ObjectCatalogModel(objectModelScene: modelScene, nodeModel: nodeModel))
        }
    
        return objectCatalogModels
    }
    
    private static var filenames: [String] {
        return [
            NodeModel.box.filename,
            NodeModel.pyramid.filename
        ]
    }
    
    private static var nodeModels: [NodeModel] {
        return [
            NodeModel.box,
            NodeModel.pyramid
        ]
    }
}

public enum NodeModel: String {
    case box
    case pyramid
    
    var filename: String {
        return self.rawValue.capitalized + ".scn"
    }
}
