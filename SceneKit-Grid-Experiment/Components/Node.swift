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
    var color: UIColor? = .blue
    var shape: Shape?
    
    // Location of object
    // Object color
    // Object shape
    
    // MARK: - Initializer
    
    init?(node: SCNNode?) {
        super.init()
        
        guard let node = node else {
            return nil
        }
        
        self.position = node.position
        self.color = node.geometry?.firstMaterial?.diffuse.contents as? UIColor
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
    
    // MARK: - Color
    
    private func encodeColor() -> [String : Float] {
        guard let components = color?.cgColor.components else {
            fatalError("Node has no identifiable color.")
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        let alpha = Float(components[3])
        
        return ["red": red, "green": green, "blue": blue, "alpha": alpha]
    }
    
    private func decode(hex: [String : Float]) -> UIColor {
        guard let red = hex["red"],
              let green = hex["green"],
              let blue = hex["blue"],
              let alpha = hex["alpha"]
        else {
            return .white
        }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    // MARK: - Encoder
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(encodePosition(), forKey: Node.positionKey)
        aCoder.encode(encodeColor(), forKey: Node.colorKey)
        aCoder.encode(encodeShape(), forKey: Node.shapeKey)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        let position = aDecoder.decodePropertyList(forKey: Node.positionKey) as! [String : Float]
        self.position = decode(position: position)
        
        let hex = aDecoder.decodePropertyList(forKey: Node.colorKey) as! [String : Float]
        self.color = decode(hex: hex)
        
        let shape = aDecoder.decodeObject(forKey: Node.shapeKey) as! String
        self.shape = decode(shape: shape)
    }
    
}
