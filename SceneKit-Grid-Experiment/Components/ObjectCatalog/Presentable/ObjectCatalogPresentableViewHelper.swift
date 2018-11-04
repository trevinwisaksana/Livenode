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
        
        // TODO: Cache these models
        for objectModelIndex in 0...3 {
            guard let modelScene = SCNScene(named: filenames[objectModelIndex]) else {
                fatalError("Cannot load model scene.")
            }
            
            let nodeModel = nodeModels[objectModelIndex]
            
            objectCatalogModels.append(ObjectCatalogModel(objectModelScene: modelScene, nodeModel: nodeModel))
        }
    
        return objectCatalogModels
    }
    
    private static var filenames: [String] {
        return [NodeModel.box.scnFilename,
                NodeModel.pyramid.scnFilename,
                NodeModel.car.scnFilename,
                NodeModel.house.scnFilename]
    }
    
    private static var nodeModels: [NodeModel] {
        return [NodeModel.box,
                NodeModel.pyramid,
                NodeModel.car,
                NodeModel.house]
    }
}

public enum NodeModel: String {
    case box
    case pyramid
    case house
    case car
    
    var scnFilename: String {
        return rawValue.capitalized + ".scn"
    }
    
    var daeFilename: String {
        return rawValue.capitalized + ".dae"
    }
}
