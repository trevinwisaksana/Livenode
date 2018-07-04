//
//  GridScene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SceneKit

final class GridScene: SCNScene {
    
    //–––– Properties ––––//
    
    let gridWidth = 20
    
    var cameraNode = SCNNode()
    var testNode: SCNNode!
    var floorNode: SCNNode!
    
    //–––– Initializer ––––//
    
    override public init() {
        super.init()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        background.contents = UIColor.gray
        
        initCamera()
    
        let testBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        testNode = SCNNode(geometry: testBox)
        testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        testNode.position = SCNVector3(0, 0.5, 0)
        testNode.name = "testNode"
        
        rootNode.addChildNode(testNode)
        
        // TODO: Rotate the SCNFloor and add a grid texture
        let floor = SCNFloor()
        floor.reflectivity = 0
        
        floorNode = SCNNode(geometry: floor)
    
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        rootNode.addChildNode(floorNode)
        
        // TODO: Fix the lighting issues
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.position = SCNVector3(0, 0, 0)
//        rootNode.addChildNode(lightNode)
        
        cameraNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        rootNode.addChildNode(ambientLightNode)
    }
    
    func initCamera() {
//        cameraNode.camera = SCNCamera()
        
//        cameraNode.position = SCNVector3(x: 0, y: -30, z: 30)
        
//        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float.pi / 3)
//
//        let zRotation = SCNMatrix4MakeRotation(Float.pi / 4, 0, 0, -1)
//        cameraNode.transform = SCNMatrix4Mult(cameraNode.transform, zRotation)
        
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
        
//        rootNode.addChildNode(cameraNode)
    }
    
    func insertNode() {
        let testBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        testNode = SCNNode(geometry: testBox)
        testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        testNode.position = SCNVector3(0, 0, 5)
        testNode.name = "testNode"
        
//        rootNode.addChildNode(testNode)
    }
    
    func showGrid() {
        let width: CGFloat = 0.95
        
        let offset: Int = 1
        
        // TODO: Only run this on "Move" mode
//        for xIndex in 0...gridWidth {
//            for yIndex in 0...gridWidth {
//                let geometry = SCNPlane(width: width, height: width)
//                let boxnode = SCNNode(geometry: geometry)
//
//                boxnode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
//                boxnode.geometry?.firstMaterial?.isDoubleSided = true
//
//                boxnode.position.x = Float(xIndex - offset)
//                boxnode.position.y = Float(yIndex - offset)
//
//                self.rootNode.addChildNode(boxnode)
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
