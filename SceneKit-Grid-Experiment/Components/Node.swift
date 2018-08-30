//
//  Node.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

enum Shape: String {
    case box
    case pyramid
    case sphere
}

public class Node: NSObject, NSCoding {
    
    // MARK: - Internal Properties
    
    private static let positionKey = "positionKey"
    private static let colorKey = "colorKey"
    private static let shapeKey = "shapeKey"
    
    var position: SCNVector3 = SCNVector3Zero
    var color: UIColor = .white
    var shape: Shape?
    
    // MARK: - Initializer
    
    init?(node: SCNNode?) {
        super.init()
        
        guard let node = node else {
            return nil
        }
        
        self.position = node.position
        self.color = node.geometry?.firstMaterial?.diffuse.contents as! UIColor
        self.shape = determine(geometry: node.geometry)
    }
    
    // MARK: - Shape
    
    private func determine(geometry: SCNGeometry?) -> Shape? {
        switch geometry?.shape {
        case "SCNBox":
            return Shape.box
        case "SCNPyramid":
            return Shape.pyramid
        case "SCNSpehere":
            return Shape.sphere
        default:
            fatalError("Shape unrecognizable.")
        }
    }
    
    private func encodeShape() -> String {
        guard let shape = shape else {
            fatalError("Shape unrecognizable.")
        }
        
        return shape.rawValue
    }
    
    private func decode(shape: String) -> Shape {
        switch shape {
        case Shape.box.rawValue:
            return Shape.box
        case Shape.pyramid.rawValue:
            return Shape.pyramid
        case Shape.sphere.rawValue:
            return Shape.sphere
        default:
            fatalError("Shape is unrecognizable.")
        }
    }
    
    // MARK: - Position
    
    private func encodePosition() -> [String : Float] {
        return ["x": position.x, "y": position.y, "z": position.z]
    }
    
    private func decode(position: [String : Float]) -> SCNVector3 {
        guard let x = position["x"], let y = position["y"], let z = position["z"] else {
            return SCNVector3Zero
        }
        
        let vector = SCNVector3(x: x, y: y, z: z)
        return vector
    }
    
    // MARK: - Encoder
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(encodePosition(), forKey: Node.positionKey)
        aCoder.encode(color.toRGBA(), forKey: Node.colorKey)
        aCoder.encode(encodeShape(), forKey: Node.shapeKey)
    }
    
    // MARK: - Decoder
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        let position = aDecoder.decodeObject(forKey: Node.positionKey) as! [String : Float]
        self.position = decode(position: position)
        
        let hex = aDecoder.decodeObject(forKey: Node.colorKey) as! [String : Float]
        self.color = UIColor.parse(hex: hex)
        
        let shape = aDecoder.decodeObject(forKey: Node.shapeKey) as! String
        self.shape = decode(shape: shape)
    }
    
}
