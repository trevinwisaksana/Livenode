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
        for objectModelIndex in 0...6 {
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
                NodeModel.plane.scnFilename,
                NodeModel.sphere.scnFilename,
                NodeModel.pyramid.scnFilename,
                NodeModel.car.scnFilename,
                NodeModel.house.scnFilename,
                NodeModel.seaplane.scnFilename]
    }
    
    private static var nodeModels: [NodeModel] {
        return [NodeModel.box,
                NodeModel.plane,
                NodeModel.sphere,
                NodeModel.pyramid,
                NodeModel.car,
                NodeModel.house,
                NodeModel.seaplane]
    }
}

public enum NodeModel: String {
    case `default`
    case box
    case plane
    case pyramid
    case sphere
    case house
    case car
    case seaplane
    
    var scnFilename: String {
        return rawValue.capitalized + ".scn"
    }
    
    var daeFilename: String {
        return rawValue.capitalized + ".dae"
    }
}
