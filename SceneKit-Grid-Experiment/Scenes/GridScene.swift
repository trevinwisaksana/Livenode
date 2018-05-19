//
//  GridScene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SceneKit

class GridScene: SCNScene {
    
    //–––– Properties ––––//
    
    let gridWidth = 20
    
    var cameraNode = SCNNode()
    
    var testNode: SCNNode!
    
    //–––– Initializer ––––//
    
    override public init() {
        super.init()
        
        initCamera()
        
        let width: CGFloat = 0.95
        
        let offset: Int = 1
        
        for xIndex in 0...gridWidth {
            for yIndex in 0...gridWidth {
                let geometry = SCNPlane(width: width, height: width)
                let boxnode = SCNNode(geometry: geometry)
                
                boxnode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                boxnode.geometry?.firstMaterial?.isDoubleSided = true
                
                boxnode.position.x = Float(xIndex - offset)
                boxnode.position.y = Float(yIndex - offset)
                
                self.rootNode.addChildNode(boxnode)
            }
        }
        
        let testBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        testNode = SCNNode(geometry: testBox)
        testNode.position = SCNVector3(0, 0, 1)
        testNode.name = "testNode"
        
        rootNode.addChildNode(testNode)
    }
    
    func initCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.name = "Titit"
        
        cameraNode.position = SCNVector3(x: 0, y: -30, z: 30)
//        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float.pi / 3)
        
        let zRotation = SCNMatrix4MakeRotation(Float.pi / 4, 0, 0, -1)
        cameraNode.transform = SCNMatrix4Mult(cameraNode.transform, zRotation)
        
//        let transformConstraint = SCNTransformConstraint(inWorldSpace: true) { (node, matrix) -> SCNMatrix4 in
//            var newMatrix = node.transform
//            let currentNode = node as SCNNode
//            
//            if currentNode.presentation.position.z > 0.0 {
//                newMatrix.m43 = 0.0
//            }
//            
//            return newMatrix
//        }
//        
//        cameraNode.constraints = [transformConstraint]
        
        rootNode.addChildNode(cameraNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}