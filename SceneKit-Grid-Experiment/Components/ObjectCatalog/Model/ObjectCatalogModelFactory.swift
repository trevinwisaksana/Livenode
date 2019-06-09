//
//  ObjectCatalogModelFactory.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/3/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol ObjectCatalogViewModel {
    var objectModelScene: SCNScene { get set }
    var nodeModel: NodeModel { get set }
}

public struct ObjectCatalogModelFactory {
    
    // MARK: - Properties
    
    private static let nodeLength: CGFloat = 1.0
    private static let sphereDiameter: CGFloat = 1.2
    
    public static func create() -> [SCNNode] {
        
        let boxGeometry = SCNBox(width: nodeLength, height: nodeLength, length: nodeLength, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        boxGeometry.name = type(of: boxGeometry.self).description()
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.changeColor(to: .matteRed)
        
        var boxNodeTransform = SCNMatrix4Identity
        boxNodeTransform = SCNMatrix4Rotate(boxNodeTransform, 0.349, 1, 0, 0)
        boxNodeTransform = SCNMatrix4Rotate(boxNodeTransform, 0.785, 0, 1, 0)
        boxNodeTransform = SCNMatrix4Rotate(boxNodeTransform, 0.250, 0, 0, 1)
        boxNode.transform = boxNodeTransform
        
        let sphereGeometry = SCNSphere(radius: sphereDiameter / 2)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        sphereGeometry.name = type(of: sphereGeometry.self).description()
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.firstMaterial?.reflective.contents = UIColor.skyBlue
        sphereNode.geometry?.firstMaterial?.reflective.intensity = 0.9
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor(r: 10, g: 10, b: 10)
        
        var sphereNodeTransform = SCNMatrix4Identity
        sphereNodeTransform = SCNMatrix4Rotate(sphereNodeTransform, 0.349, 1, 0, 0)
        sphereNodeTransform = SCNMatrix4Rotate(sphereNodeTransform, 0.785, 0, 1, 0)
        sphereNodeTransform = SCNMatrix4Rotate(sphereNodeTransform, 0.250, 0, 0, 1)
        sphereNode.transform = sphereNodeTransform
        
        let pyramidGeometry = SCNPyramid(width: nodeLength, height: nodeLength, length: nodeLength)
        pyramidGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidGeometry.name = type(of: pyramidGeometry.self).description()
        let pyramidNode = SCNNode(geometry: pyramidGeometry)
        pyramidNode.pivot = SCNMatrix4MakeTranslation(0, 0.55, 0)
        pyramidNode.changeColor(to: .orange)
        
        
        guard let carNode = SCNNode.daeToSCNNode(filepath: "Car.scn") else {
            return []
        }
        
        carNode.geometry?.name = NodeType.LVNCar.string
        carNode.pivot = SCNMatrix4MakeTranslation(0, 0.55, 0)
        
        guard let houseNode = SCNNode.daeToSCNNode(filepath: "House.scn") else {
            return []
        }
        
        houseNode.geometry?.name = NodeType.LVNHouse.string
        houseNode.pivot = SCNMatrix4MakeTranslation(0, 2.5, 0)
        
        guard let treeNode = SCNNode.daeToSCNNode(filepath: "Tree.scn") else {
            return []
        }
        
        treeNode.geometry?.name = NodeType.LVNTree.string
        treeNode.pivot = SCNMatrix4MakeTranslation(0, 0.55, 0)
        
        var pyramidNodeTransform = SCNMatrix4Identity
        pyramidNodeTransform = SCNMatrix4Rotate(pyramidNodeTransform, 0.349, 1, 0, 0)
        pyramidNodeTransform = SCNMatrix4Rotate(pyramidNodeTransform, 0.785, 0, 1, 0)
        pyramidNodeTransform = SCNMatrix4Rotate(pyramidNodeTransform, 0.250, 0, 0, 1)
        pyramidNode.transform = pyramidNodeTransform
        
        let planeGeometry = SCNPlane(width: nodeLength, height: nodeLength)
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        planeGeometry.firstMaterial?.isDoubleSided = true
        planeGeometry.name = type(of: planeGeometry.self).description()
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.changeColor(to: .lightGray)
        
        var planeNodeTransform = SCNMatrix4Identity
        planeNodeTransform = SCNMatrix4Rotate(planeNodeTransform, 1.27, 1, 0, 0)
        planeNodeTransform = SCNMatrix4Rotate(planeNodeTransform, 0.785, 0, 1, 0)
        planeNodeTransform = SCNMatrix4Rotate(planeNodeTransform, -0.220, 0, 0, 1)
        planeNode.transform = planeNodeTransform
        
        var carNodeTransform = SCNMatrix4Identity
        carNodeTransform = SCNMatrix4Rotate(carNodeTransform, -0.27, 0, 1, 0)
        carNodeTransform = SCNMatrix4Rotate(carNodeTransform, 0.1, 1, 0, 0)
        carNode.transform = carNodeTransform
        carNode.scale = SCNVector3(0.4, 0.4, 0.4)
        
        var houseNodeTransform = SCNMatrix4Identity
        houseNodeTransform = SCNMatrix4Rotate(houseNodeTransform, -0.27, 0, 1, 0)
        houseNodeTransform = SCNMatrix4Rotate(houseNodeTransform, 0.1, 1, 0, 0)
        houseNode.transform = houseNodeTransform
        houseNode.scale = SCNVector3(0.08, 0.08, 0.08)
        
        var treeNodeTransform = SCNMatrix4Identity
        treeNodeTransform = SCNMatrix4Rotate(treeNodeTransform, -0.27, 0, 1, 0)
        treeNodeTransform = SCNMatrix4Rotate(treeNodeTransform, 0.1, 1, 0, 0)
        treeNode.transform = treeNodeTransform
        treeNode.scale = SCNVector3(0.04, 0.04, 0.04)
        
        return [boxNode, pyramidNode, sphereNode, planeNode, carNode, houseNode, treeNode]
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
    case tree
    
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
    case SCNSphere
    
    case LVNCar
    case LVNHouse
    case LVNTree
    
    var string: String {
        return rawValue
    }
}
