//
//  ObjectCatalogPresentableViewHelper.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class ObjectCatalogModel: NSObject, NSCoding, ObjectCatalogViewModel {
    public var objectModelScene: SCNScene
    public var nodeModel: NodeModel
    
    init(objectModelScene: SCNScene, nodeModel: NodeModel) {
        self.objectModelScene = objectModelScene
        self.nodeModel = nodeModel
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(objectModelScene, forKey: "ObjectModelScene")
        aCoder.encode(nodeModel.rawValue, forKey: "NodeModel")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.objectModelScene = aDecoder.decodeObject(forKey: "ObjectModelScene") as! SCNScene
        self.nodeModel = NodeModel(rawValue: aDecoder.decodeObject(forKey: "NodeModel") as! String) ?? .default
    }
}

public struct ObjectCatalogModelFactory {
    public static func create() -> [ObjectCatalogModel] {
        var objectCatalogModels: [ObjectCatalogModel] = []
        
        if UserDefaults.standard.object(forKey: "ObjectCatalogModels") == nil {
            for objectModelIndex in 0...6 {
                guard let modelScene = SCNScene(named: filenames[objectModelIndex]) else {
                    fatalError("Cannot load model scene.")
                }
                
                let nodeModel = nodeModels[objectModelIndex]
                let objectCatalogModel = ObjectCatalogModel(objectModelScene: modelScene, nodeModel: nodeModel)
                objectCatalogModels.append(objectCatalogModel)
            }
            
            do {
                let objectCatalogModelsData = try NSKeyedArchiver.archivedData(withRootObject: objectCatalogModels, requiringSecureCoding: false)
                UserDefaults.standard.set(objectCatalogModelsData, forKey: "ObjectCatalogModels")
            } catch {
                fatalError("Cannot save object catalog models.")
            }
            
        } else {
            let cachedModels = UserDefaults.standard.object(forKey: "ObjectCatalogModels") as! Data
            
            do {
                let unarchivedModels = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cachedModels) as! [ObjectCatalogModel]
                objectCatalogModels.append(contentsOf: unarchivedModels)
            } catch {
                fatalError("Failed to retrieve object catalog models.")
            }
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
    case floor
    
    var scnFilename: String {
        return rawValue.capitalized + ".scn"
    }
    
    var daeFilename: String {
        return rawValue.capitalized + ".dae"
    }
}

public enum NodeType: String {
    case `default`
    case SCNPlane
    case SCNBox
    case SCNCar
    
    var string: String {
        return rawValue
    }
}
