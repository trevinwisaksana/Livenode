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

// TODO: Create a savable version of SCNNode
class Node: NSObject, NSCoding {
    
    // MARK: - Internal Properties
    
    private static let positionKey = "positionKey"
    
    var position: SCNVector3 = SCNVector3Zero
    var color: UIColor? = .white
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
            fatalError("Unrecognizable shape.")
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
    
//    private func encodeColor() -> (r: Float, g: Float, b: Float, a: Float) {
//        return (r: color?.cgColor., g: Float, b: Float, a: color?.cgColor.alpha)
//    }
    
    // MARK: - Encoder
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(encodePosition(), forKey: Node.positionKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        let position = aDecoder.decodeObject(forKey: Node.positionKey) as! [String : Float]
        self.position = decode(position: position)
        
        
    }
    
}
