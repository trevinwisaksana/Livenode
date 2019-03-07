//
//  ObjectCatalogModelFactory.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public struct ObjectCatalogModelFactory {
    
    // MARK: - Properties
    
    private static let nodeLength: CGFloat = 2.0
    
    public static func create() -> [SCNNode] {
        
        let boxGeometry = SCNBox(width: nodeLength, height: nodeLength, length: nodeLength, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        boxGeometry.name = type(of: boxGeometry.self).description()
        let boxNode = SCNNode(geometry: boxGeometry)
        
        let planeGeometry = SCNPlane(width: nodeLength, height: nodeLength)
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        planeGeometry.firstMaterial?.isDoubleSided = true
        planeGeometry.name = type(of: planeGeometry.self).description()
        let planeNode = SCNNode(geometry: planeGeometry)
        
        let sphereGeometry = SCNSphere(radius: nodeLength / 2)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        sphereGeometry.name = type(of: sphereGeometry.self).description()
        let sphereNode = SCNNode(geometry: sphereGeometry)
        
        let pyramidGeometry = SCNPyramid(width: nodeLength, height: nodeLength, length: nodeLength)
        pyramidGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidGeometry.name = type(of: pyramidGeometry.self).description()
        let pyramidNode = SCNNode(geometry: pyramidGeometry)
        pyramidNode.pivot = SCNMatrix4MakeTranslation(0, 1, 0)
        
        return [boxNode, planeNode, sphereNode, pyramidNode]
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
    case SCNSphere
    
    var string: String {
        return rawValue
    }
}
