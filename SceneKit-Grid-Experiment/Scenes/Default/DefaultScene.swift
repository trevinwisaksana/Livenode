//
//  DefaultScene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class DefaultScene: SCNScene, DefaultSceneViewModel {
    
    // MARK: - Internal Properties
    
    private static let gridWidth: Int = 20
    private static let gridTileWidth: CGFloat = 1
    private static let nodeBottomMargin: Float = 0.5
    
    // TODO: Create node extension that sets name for itself
    private var cameraNode: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.camera = SCNCamera()
        return node
    }()
    
    private var gridContainer: SCNNode = {
        let node = SCNNode(geometry: nil)
        return node
    }()
    
    private var presentationNodeContainer: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = "presentationNodeContainer"
        return node
    }()
    
    private var floorNode: SCNNode = {
        let floorGeometry = SCNFloor()
        floorGeometry.reflectivity = 0
        floorGeometry.firstMaterial?.lightingModel = .constant
        
        let node = SCNNode(geometry: floorGeometry)
        node.position = SCNVector3(0, -0.1, 0)
        node.name = "floorNode"
        node.changeColor(to: .white)
        
        return node
    }()
    
    // MARK: - Public Properties
    
    // TODO: Remove the local nodeSelected variable and use the State version
    public var nodeSelected: SCNNode?
    public var lastNodeSelected: SCNNode?
    public var currentNodeHighlighted: SCNNode?
    public var nodeAnimationTarget: SCNNode?
    
    public var didSelectANode: Bool = false
    public var isGridDisplayed: Bool = false
    public var isSelectingAnimationTargetLocation: Bool = false
    
    public var backgroundColor: UIColor {
        return background.contents as! UIColor
    }
    
    public lazy var floorColor: UIColor? = {
        return floorNode.color
    }()
    
    // MARK: - Setup
    
    override public init() {
        super.init()

        setup()
    }
    
    private func setup() {
        rootNode.addChildNode(gridContainer)
        rootNode.addChildNode(presentationNodeContainer)
        rootNode.addChildNode(floorNode)
        
        createGrid(with: CGSize(width: DefaultScene.gridWidth, height: DefaultScene.gridWidth))
        
        background.contents = UIColor.aluminium
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Presentation
    
    public func prepareForPresentation() {
        floorNode.isHidden = true
        hideGrid()
    }
    
    public func didFinishPresentation() {
        floorNode.isHidden = false
    }
    
    // MARK: - Node Selection
    
    public func didSelectNode(_ node: SCNNode?) {
        if isSelectingAnimationTargetLocation && node?.name != "floorNode" {
            nodeSelected = node
            node?.changeColor(to: .green)
            
            if lastNodeSelected != nil {
                lastNodeSelected?.changeColor(to: .clear)
            }
            
            lastNodeSelected = nodeSelected
            didSelectANode = true
            
            return
        }
        
        let isCorrectNodeSelected = node?.name == "floorNode" || node?.name == "tileBorder"
        if node == nil || node?.name == nil || isCorrectNodeSelected {
            didUnselectNode()
            return
        }
        
        nodeSelected = node
        State.nodeSelected = nodeSelected
        highlight(nodeSelected)
        
        didSelectANode = true
    }
    
    public func didUnselectNode() {
        nodeSelected = nil
        State.nodeSelected = nil
        didSelectANode = false
        unhighlight(currentNodeHighlighted)
    }
    
    // MARK: - Node Insertion
    
    func insertBox() {
        // TODO: Set function to private
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        boxNode.position = SCNVector3(0, DefaultScene.nodeBottomMargin, 0)
        boxNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: "presentationNodeContainer", recursively: true) else {
            return
        }
        
        presentationNodeContainer.addChildNode(boxNode)
    }
    
    func insertPyramid() {
        // TODO: Set function to private
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidNode.position = SCNVector3(0, 0, 0)
        pyramidNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: "presentationNodeContainer", recursively: true) else {
            return
        }
        
        presentationNodeContainer.addChildNode(pyramidNode)
    }
    
    // MARK: - Grid
    
    private func createGrid(with size: CGSize) {
        for xIndex in 0...Int(size.width) {
            for zIndex in 0...Int(size.height) {
                let tileGeometry = SCNPlane(width: DefaultScene.gridTileWidth, height: DefaultScene.gridTileWidth)
                
                let tileNode = SCNNode(geometry: tileGeometry)
                tileNode.changeColor(to: .clear)
                tileNode.eulerAngles = SCNVector3(-1.5708, 0, 0)
                
                if zIndex > 10 {
                    tileNode.position.z = Float(zIndex - Int(size.height + 1))
                } else {
                    tileNode.position.z = Float(zIndex)
                }
                
                if xIndex > 10 {
                    tileNode.position.x = Float(xIndex - Int(size.width + 1))
                } else {
                    tileNode.position.x = Float(xIndex)
                }
                
                createBorder(for: tileNode)
                
                gridContainer.addChildNode(tileNode)
            }
        }
    }
    
    private func createBorder(for node: SCNNode?) {
        guard let node = node else {
            return
        }
        
        let (min, max) = node.boundingBox
        let zCoord: Float = 0.0
        let topLeft = SCNVector3(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3(min.x, min.y, zCoord)
        let topRight = SCNVector3(max.x, max.y, zCoord)
        let bottomRight = SCNVector3(max.x, min.y, zCoord)
        
        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)
        
        [bottomSide, leftSide, rightSide, topSide].forEach {
            node.name = "tileBorder"
            node.addChildNode($0)
        }
    }
    
    private func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: origin, toVector: destination)

        let lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color

        return lineNode
    }

    private func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
    
    private func showGrid() {
        gridContainer.enumerateChildNodes { (node, _) in
            node.isHidden = false
        }
        
        isGridDisplayed = true
    }
    
    private func hideGrid() {
        // TODO: Fix issue where we cannot unhide grid
        gridContainer.enumerateChildNodes { (node, _) in
            node.isHidden = true
        }
        
        isGridDisplayed = false
    }
    
    // MARK: - Node Movement
    
    public func move(targetNode: SCNNode, in sceneView: SCNView) {
        let isCorrectNodeSelected = targetNode.name != "nodeHighlight" && targetNode.name != "floorNode"
        if didSelectANode && isCorrectNodeSelected {
            let nodeXPos = targetNode.position.x
            let nodeZPos = targetNode.position.z
            
            if nodeSelected?.isMovable ?? false {
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: DefaultScene.nodeBottomMargin, z: nodeZPos)
                sceneView.allowsCameraControl = false
            }
        }
    }
    
    // MARK: - Node Color
    
    public func modifyNodeColor(to color: UIColor) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        node?.changeColor(to: color)
    }
    
    // MARK: - Node Animation
    
    func setNodeAnimationTarget() {
        nodeAnimationTarget = nodeSelected
        State.nodeAnimationTarget = nodeSelected
    }
    
    func setMoveAnimationTarget(location: SCNVector3) {
        
    }
    
    func addMoveAnimation(toLocation location: SCNVector3, withDuration duration: TimeInterval) {
        let action = SCNAction.move(by: location, duration: duration)
        nodeAnimationTarget?.runAction(action, forKey: "Move")
    }
    
    // MARK: - Scene Actions
    
    public func didSelectScene(action: String) {
        switch action {
        case Action.cut.capitalized:
            nodeSelected?.copy()
            nodeSelected?.removeFromParentNode()
        case Action.copy.capitalized:
            nodeSelected?.copy()
        case Action.paste.capitalized:
            break
        case Action.delete.capitalized:
            nodeSelected?.removeFromParentNode()
        case Action.move.capitalized:
            nodeSelected?.isMovable = true
        case Action.pin.capitalized:
            nodeSelected?.isMovable = false
            didSelectANode = false
        default:
            break
        }
    }
    
    // MARK: - Node Highlight
    
    // TODO: Find solution that doesn't only work with boxes
    private func highlight(_ nodeSelected: SCNNode?) {
        guard let node = nodeSelected else {
            return
        }
    
        if currentNodeHighlighted != nil {
            return
        }
        
        // TODO: Make the dimensions the same with the node selected
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        let nodeHighlight = SCNNode(geometry: box)
        nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: .boxWireframe)
        nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        nodeHighlight.name = "nodeHighlight"
        
        node.addChildNode(nodeHighlight)
        
        currentNodeHighlighted = node
    }

    private func unhighlight(_ lastNodeSelected: SCNNode?) {
        guard let node = lastNodeSelected else {
            return
        }
        
        let nodeHighlight = node.childNode(withName: "nodeHighlight", recursively: true)
        nodeHighlight?.removeFromParentNode()
        
        currentNodeHighlighted = nil
    }

}
