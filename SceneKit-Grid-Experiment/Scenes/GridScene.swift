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
        
        background.contents = UIColor.gray
    
        let testBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        testNode = SCNNode(geometry: testBox)
        testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        testNode.position = SCNVector3(0, 0.5, 0)
        testNode.name = "testNode"
        
        rootNode.addChildNode(testNode)
        
        // TODO: Add a grid texture to the SCNFloor
        let floor = SCNFloor()
        floor.reflectivity = 0
        
        floorNode = SCNNode(geometry: floor)
        floorNode.name = "Floor"
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        
        rootNode.addChildNode(floorNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    
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
    
    // MARK: - Insertion
    
    func insertBox() {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        boxNode.position = SCNVector3(0, 0.5, 5)
        
        // TODO: Change the name
        boxNode.name = "testNode"
        
        rootNode.addChildNode(boxNode)
    }
    
    func insertPyramid() {
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidNode.position = SCNVector3(0, 0.5, 5)
        
        // TODO: Change the name
        pyramidNode.name = "testNode"
        
        rootNode.addChildNode(pyramidNode)
    }
    
    // MARK: - Grid
    
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
    
    // MARK: - Node Highlight
    
//    func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
//        let line = lineFrom(vector: origin, toVector: destination)
//
//        let lineNode = SCNNode(geometry: line)
//        lineNode.geometry?.firstMaterial?.diffuse.contents = color
//
//        return lineNode
//    }
//
//    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
//        let indices: [Int32] = [0, 1]
//
//        let source = SCNGeometrySource(vertices: [vector1, vector2])
//        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
//
//        return SCNGeometry(sources: [source], elements: [element])
//    }
//
//    func highlightNode(_ node: SCNNode?) {
//
//        guard let node = node else {
//            return
//        }
//
//        let (min, max) = node.boundingBox
//        let zCoord = node.position.z
//        let topLeft = SCNVector3Make(min.x, max.y, zCoord)
//        let bottomLeft = SCNVector3Make(min.x, min.y, zCoord)
//        let topRight = SCNVector3Make(max.x, max.y, zCoord)
//        let bottomRight = SCNVector3Make(max.x, min.y, zCoord)
//
//        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
//        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
//        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
//        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)
//
//        [bottomSide, leftSide, rightSide, topSide].forEach {
//            $0.name = "highlightNode"
//            node.addChildNode($0)
//        }
//    }
//
//    func unhighlightNode(_ node: SCNNode?) {
//        guard let node = node else {
//            return
//        }
//
//        let highlightningNodes = node.childNodes { (child, stop) -> Bool in
//            child.name == "highlightNode"
//        }
//
//        highlightningNodes.forEach {
//            $0.removeFromParentNode()
//        }
//    }

}
