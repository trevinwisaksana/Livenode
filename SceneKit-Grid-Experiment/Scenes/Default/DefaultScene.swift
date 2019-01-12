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
    
    private var lastWidthRatio: Float = 0
    private var lastHeightRatio: Float = 0
    private var pinchAttenuation: CGFloat = 1.0  // 1.0: very fast ---- 100.0 very slow
    
    private var camera: SCNCamera = {
        let camera = SCNCamera()
        camera.usesOrthographicProjection = false
        camera.automaticallyAdjustsZRange = true
        camera.focalLength = 30
        return camera
    }()
    
    private var cameraNode: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = Constants.Node.camera
        node.position = SCNVector3(0, 0, 50)
        return node
    }()
    
    private var cameraOrbit: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = Constants.Node.cameraOrbit
        node.eulerAngles = SCNVector3(-0.26, -0.025, 0)
        return node
    }()
    
    private var gridContainer: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = Constants.Node.gridContainer
        return node
    }()
    
    private var presentationNodeContainer: SCNNode = {
        let node = SCNNode(geometry: nil)
        node.name = Constants.Node.presentationNodeContainer
        return node
    }()
    
    private var floorNode: SCNNode = {
        let floorGeometry = SCNFloor()
        floorGeometry.reflectivity = 0
        floorGeometry.firstMaterial?.lightingModel = .constant
        
        let node = SCNNode(geometry: floorGeometry)
        node.position = SCNVector3(0, -0.1, 0)
        node.name = Constants.Node.floor
        
        node.changeColor(to: .white)
        
        return node
    }()
    
    // MARK: - Public Properties
    
    // TODO: Remove the local nodeSelected variable and use the State version
    public var nodeSelected: SCNNode?
    public var lastNodeSelected: SCNNode?
    public var currentNodeHighlighted: SCNNode?
    public var recentNodeAdded: SCNNode?
    public var nodeCopied: SCNNode?
    public var originalNodePosition: SCNVector3?
    
    public var nodeAnimationTarget: SCNNode? {
        didSet {
            nodeAnimationTargetOriginalPosition = nodeAnimationTarget?.position
            nodeAnimationTargetOriginalRotation = nodeAnimationTarget?.rotation
        }
    }
    
    public var nodeAnimationTargetOriginalPosition: SCNVector3?
    public var nodeAnimationTargetOriginalRotation: SCNVector4?
    
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
        
        cameraNode.camera = camera
        cameraOrbit.addChildNode(cameraNode)
        rootNode.addChildNode(cameraOrbit)
        
        createGrid(with: CGSize(width: DefaultScene.gridWidth, height: DefaultScene.gridWidth))
        
        hideGrid()
        
        background.contents = UIColor.aluminium
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func hideGrid() {
        let gridContainer = rootNode.childNode(withName: Constants.Node.gridContainer, recursively: true)
        gridContainer?.enumerateChildNodes { (node, stop) in
            node.isHidden = true
        }
    }
    
    func showGrid() {
        let gridContainer = rootNode.childNode(withName: Constants.Node.gridContainer, recursively: true)
        gridContainer?.enumerateChildNodes { (node, stop) in
            node.isHidden = false
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
            node.name = Constants.Node.tileBorder
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
    
    // MARK: - Node Selection
    
    public func didSelectNode(_ node: SCNNode?) {
        if isSelectingAnimationTargetLocation && node?.name == Constants.Node.tileBorder {
            
            nodeSelected = node
            node?.changeColor(to: .green)
            
            if lastNodeSelected != nil {
                lastNodeSelected?.changeColor(to: .clear)
            }
            
            lastNodeSelected = nodeSelected
            didSelectANode = true
            
            return
        }
        
        let isCorrectNodeSelected = node?.name == Constants.Node.floor || node?.name == Constants.Node.tileBorder
        if node == nil || node?.name == nil || isCorrectNodeSelected {
            didDeselectNode()
            return
        }
        
        nodeSelected = node
        State.nodeSelected = nodeSelected
        
        // TODO: Figure out how to highlight the node
//        highlight(nodeSelected)
        
        didSelectANode = true
    }
    
    public func didDeselectNode() {
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
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = boxNode
        recentNodeAdded = boxNode
        
        presentationNodeContainer.addChildNode(boxNode)
    }
    
    func insertSphere() {
        // TODO: Set function to private
        let sphere = SCNSphere(radius: 1)
        let sphereNode = SCNNode(geometry: sphere)
        
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        sphereNode.position = SCNVector3(0, 0.9, 0)
        sphereNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = sphereNode
        recentNodeAdded = sphereNode
        
        presentationNodeContainer.addChildNode(sphereNode)
    }
    
    func insertPyramid() {
        // TODO: Set function to private
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidNode.position = SCNVector3(0, 0, 0)
        pyramidNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = pyramidNode
        recentNodeAdded = pyramidNode
        
        presentationNodeContainer.addChildNode(pyramidNode)
    }
    
    func insertPlane() {
        // TODO: Fix issue where plane cannot be moved easily if it's too big
        let plane = SCNPlane(width: 5, height: 5)
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        planeNode.eulerAngles = SCNVector3(-1.57, 0, 0)
        planeNode.position = SCNVector3(0, 0.05, 0)
        planeNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = planeNode
        recentNodeAdded = planeNode
        
        presentationNodeContainer.addChildNode(planeNode)
    }
    
    func insertCar() {
        guard let carNode = SCNCarNode(node: daeToSCNNode(filepath: "Car.scn")) else {
            return
        }

        carNode.position = SCNVector3(0, 0, 0)
        carNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = carNode
        recentNodeAdded = carNode
        
        presentationNodeContainer.addChildNode(carNode)
    }
    
    func insertHouse() {
        guard let houseNode = daeToSCNNode(filepath: "House.scn") else {
            return
        }
        
        houseNode.position = SCNVector3(0, 0, 0)
        houseNode.scale = SCNVector3(0.2, 0.2, 0.2)
        houseNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = houseNode
        recentNodeAdded = houseNode
        
        presentationNodeContainer.addChildNode(houseNode)
    }
    
    func insertSeaplane() {
        guard let seaplaneNode = daeToSCNNode(filepath: "Seaplane.scn") else {
            return
        }
        
        seaplaneNode.position = SCNVector3(0, 0.5, 0)
        seaplaneNode.scale = SCNVector3(0.2, 0.2, 0.2)
        seaplaneNode.name = "\(Int.random(in: 0...1000))"
        
        guard let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true) else {
            return
        }
        
        nodeSelected = seaplaneNode
        recentNodeAdded = seaplaneNode
        
        presentationNodeContainer.addChildNode(seaplaneNode)
    }
    
    // MARK: - Node Movement
    
    public func move(targetNode: SCNNode, in sceneView: SCNView) {
        let isCorrectNodeSelected = targetNode.name != Constants.Node.highlight && targetNode.name != Constants.Node.floor
        if didSelectANode && isCorrectNodeSelected && nodeSelected?.isMovable ?? false {
            let nodeXPos = targetNode.position.x
            let nodeZPos = targetNode.position.z
            
            switch nodeSelected?.type ?? .default {
            case .plane:
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: -0.05, z: nodeZPos)
            case .box:
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: 0.5, z: nodeZPos)
            case .pyramid:
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: 0, z: nodeZPos)
            case .sphere:
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: 0.9, z: nodeZPos)
            default:
                nodeSelected?.position = SCNVector3(x: nodeXPos, y: DefaultScene.nodeBottomMargin, z: nodeZPos)
            }
        }
    }
    
    public func changeNodePosition(to position: SCNVector3) {
        nodeSelected?.position = SCNVector3(x: position.x, y: position.y, z: position.z)
    }
    
    public func changeNodeRotation(toAngle angle: Float) {
        nodeSelected?.eulerAngles.y = angle
    }
    
    public func resetToOriginalNodeposition() {
        guard let originalPosition = originalNodePosition else { return }
        nodeSelected?.position = originalPosition
    }
    
    // MARK: - Node Color
    
    public func modifyNodeColor(to color: UIColor) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        node?.changeColor(to: color)
    }
    
    // MARK: - Node Size
    
    public func modifyPlaneNode(length: CGFloat) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        // The variable name "length" is preferred as it may confuse the rest of the code
        (node?.geometry as! SCNPlane).height = length
    }
    
    public func modifyPlaneNode(width: CGFloat) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        (node?.geometry as! SCNPlane).width = width
    }
    
    // MARK: - Node Animation
    
    func setNodeAnimationTarget() {
        nodeAnimationTarget = nodeSelected
        State.nodeAnimationTarget = nodeSelected
    }
    
    func playAnimation() {
        guard let originalNodePosition = nodeAnimationTargetOriginalPosition,
              let originalNodeRotation = nodeAnimationTargetOriginalRotation
        else {
            return
        }
        
        nodeAnimationTarget?.playAllAnimations(completionHandler: {
            self.nodeAnimationTarget?.position = originalNodePosition
            self.nodeAnimationTarget?.rotation = originalNodeRotation
        })
    }
    
    func didUpdateAnimationDuration(_ duration: TimeInterval, forAnimationAtIndex index: Int) {
        let animation = nodeAnimationTarget?.actions[index]
        animation?.duration = duration
    }
    
    // MARK: - Move Animation
    
    func addMoveAnimation(_ animation: MoveAnimationAttributes) {
        let targetLocation = SCNVector3(x: animation.targetLocation.x, y: 0.5, z: animation.targetLocation.z)
        guard let duration = animation.duration else { return }
        let moveAction = SCNAction().move(to: targetLocation, duration: duration)
        
        nodeAnimationTarget?.addAction(moveAction, forKey: .move)
    }
    
    func didUpdateMoveAnimationLocation(_ location: SCNVector3, forAnimationAtIndex index: Int) {
        let animation = nodeAnimationTarget?.actions[index]
        guard let duration = animation?.duration else { return }
        
        let updatedLocation = SCNVector3(location.x, 0.5, location.z)
        let updatedAnimation = SCNAction().move(to: updatedLocation, duration: duration)
        
        nodeAnimationTarget?.actions[index] = updatedAnimation
    }
    
    func displayMoveAnimationTargetLocation(_ location: SCNVector3) {
        let targetIndicatorGeometry = SCNPlane(width: DefaultScene.gridTileWidth, height: DefaultScene.gridTileWidth)
        let targetIndicatorNode = SCNNode(geometry: targetIndicatorGeometry)
        targetIndicatorNode.name = "MoveAnimationTargetLocationIndicator"
        
        targetIndicatorNode.changeColor(to: .green)
        targetIndicatorNode.eulerAngles = SCNVector3(-1.5708, 0, 0)
        targetIndicatorNode.position = SCNVector3(location.x, 0.0, location.z)
        
        rootNode.addChildNode(targetIndicatorNode)
    }
    
    func hideMoveAnimationTargetLocation() {
        let targetIndicatorNode = rootNode.childNode(withName: "MoveAnimationTargetLocationIndicator", recursively: true)
        targetIndicatorNode?.removeFromParentNode()
    }
    
    // MARK: - Rotate Animation
    
    func addRotateAnimation(_ animation: RotateAnimationAttributes) {
        guard let currentLocation = nodeAnimationTarget?.position else {
            return
        }
        
        guard let angle = animation.angle, let duration = animation.duration else {
            return
        }
        
        let rotateAction = SCNAction().rotate(by: angle, aroundAxis: currentLocation, duration: duration)
        nodeAnimationTarget?.addAction(rotateAction, forKey: .rotate)
    }
    
    func didUpdateRotateAnimation(angle: CGFloat, forAnimationAtIndex index: Int) {
        let animation = nodeAnimationTarget?.actions[index]
        guard let duration = animation?.duration,
              let currentLocation = nodeAnimationTarget?.position
        else {
            return
        }
        
        let updatedAnimation = SCNAction().rotate(by: angle, aroundAxis: currentLocation, duration: duration)
        nodeAnimationTarget?.actions[index] = updatedAnimation
    }
    
    // MARK: - Speech Bubble Animation
    
    func addSpeechBubbleAnimation(_ animation: SpeechBubbleAnimationAttributes, on sceneView: SCNView) {
        createSpeechBubblePopover(duration: animation.duration ?? 0.25)
    }
    
    private func createSpeechBubblePopover(duration: TimeInterval) {
        guard let nodeAnimationTarget = nodeAnimationTarget else {
            return
        }
        
        let text = SCNText(string: "Test", extrusionDepth: 0)
        text.firstMaterial?.isDoubleSided = true
        let speechBubbleNode = SCNNode(geometry: text)
        
        speechBubbleNode.name = Constants.Node.speechBubble
        speechBubbleNode.scale = SCNVector3(0.1, 0.1, 0.1)
        speechBubbleNode.opacity = 0
        
        let (min, max) = speechBubbleNode.boundingBox
        
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        speechBubbleNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        let background = SCNPlane(width: 30, height: 15)
        background.cornerRadius = 1
        background.firstMaterial?.diffuse.contents = UIColor.white
        background.firstMaterial?.isDoubleSided = true
        
        let backgroundNode = SCNNode(geometry: background)
        backgroundNode.changeColor(to: .gray)
        speechBubbleNode.addChildNode(backgroundNode)
        
        switch nodeAnimationTarget.type {
        case .box:
            speechBubbleNode.position = SCNVector3(0, 1.5, 0)
            backgroundNode.position = SCNVector3(dx, dy, dz - 0.1)
            
        case .plane:
            speechBubbleNode.position = SCNVector3(0, 1, 0)
            speechBubbleNode.eulerAngles = SCNVector3(1.57, 0, 0)
            
        case .car:
            // TODO: Fix bug where car node isn't recognized
            speechBubbleNode.position = SCNVector3(0, 3, 0)
            backgroundNode.position = SCNVector3(dx, dy, dz - 0.1)
            
        default:
            speechBubbleNode.position = SCNVector3(0, 3, 0)
            backgroundNode.position = SCNVector3(dx, dy, dz - 0.1)
        }
        
        // TODO: Fix the duration slider because it's not rounding up numbers
        let fadeInAnimation = SCNAction.fadeIn(duration: 0.15)
        fadeInAnimation.timingMode = .easeInEaseOut
        nodeAnimationTarget.addAction(fadeInAnimation, forKey: .speechBubble)
        
        nodeAnimationTarget.addChildNode(speechBubbleNode)
    }
    
    // MARK: - Delay Animation
    
    func addDelayAnimation(_ animation: DelayAnimationAttributes) {
        guard let duration = animation.duration else {
            return
        }
        
        let updatedAnimation = SCNAction().wait(duration: duration)
        nodeAnimationTarget?.addAction(updatedAnimation, forKey: .delay)
    }
    
    func didUpdateDelayAnimation(duration: TimeInterval, forAnimationAtIndex index: Int) {
        let updatedAnimation = SCNAction().wait(duration: duration)
        nodeAnimationTarget?.actions[index] = updatedAnimation
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
        nodeHighlight.name = Constants.Node.highlight
        
        node.addChildNode(nodeHighlight)
        
        currentNodeHighlighted = node
    }

    private func unhighlight(_ lastNodeSelected: SCNNode?) {
        guard let node = lastNodeSelected else {
            return
        }
        
        let nodeHighlight = node.childNode(withName: Constants.Node.highlight, recursively: true)
        nodeHighlight?.removeFromParentNode()
        
        currentNodeHighlighted = nil
    }
    
    func resetLastNodeSelected() {
        lastNodeSelected?.changeColor(to: .clear)
        lastNodeSelected = nil
    }
    
    // MARK: - Scene Actions
    
    public func didSelectSceneAction(_ action: Action) {
        switch action {
        case .cut:
            nodeSelected?.copy()
            nodeSelected?.removeFromParentNode()
            
        case .copy:
            nodeCopied = nodeSelected
            
        case .paste:
            guard let nodeCloned = nodeCopied?.duplicate() else { return }
            
            let presentationNodeContainer = rootNode.childNode(withName: Constants.Node.presentationNodeContainer, recursively: true)
            presentationNodeContainer?.addChildNode(nodeCloned)
            
        case .delete:
            nodeSelected?.removeFromParentNode()
            
        case .move:
            nodeSelected?.isMovable = true
            originalNodePosition = nodeSelected?.position
            
        case .pin:
            nodeSelected?.isMovable = false
            didSelectANode = false
            recentNodeAdded = nil
            
        default:
            break
        }
    }

    // MARK: - Camera Movement
    // TODO: Add two-finger rotate
    
    func disableCameraControl(using panGesture: UIPanGestureRecognizer) {
        panGesture.isEnabled = false
    }
    
    func enableCameraControl(using panGesture: UIPanGestureRecognizer) {
        panGesture.isEnabled = true
    }
    
    func limitCameraRotation(using panGesture: UIPanGestureRecognizer) {
        guard let cameraOrbit = rootNode.childNode(withName: Constants.Node.cameraOrbit, recursively: true) else {
            return
        }
        
        guard let view = panGesture.view else { return }
        let translation = panGesture.translation(in: view)
        
        let widthRatio = Float(translation.x) / Float(view.frame.size.width) + lastWidthRatio
        var heightRatio = Float(translation.y) / Float(view.frame.size.height) + lastHeightRatio
        
        // Max Contraints
        if heightRatio >= 0.995 {
            heightRatio = 0.995
        }
        
        // Min Constraints
        if heightRatio <= 0.005 {
            heightRatio = 0.005
        }
        
        if panGesture.state == .changed {
            cameraOrbit.eulerAngles.y = (-2 * Float.pi) * widthRatio
            cameraOrbit.eulerAngles.x = -Float.pi * heightRatio
        }
        
        if panGesture.state == .ended {
            lastWidthRatio = widthRatio.truncatingRemainder(dividingBy: 1)
            lastHeightRatio = heightRatio.truncatingRemainder(dividingBy: 1)
        }
    }
    
    func didAdjustCameraZoom(using pinchGesture: UIPinchGestureRecognizer) {
        guard let camera = rootNode.childNode(withName: Constants.Node.camera, recursively: true)?.camera else {
            return
        }
        
        if pinchGesture.state == .changed {
            if camera.fieldOfView <= 5 {
                camera.fieldOfView = 5.01
            } else {
                camera.fieldOfView -= (pinchGesture.velocity / pinchAttenuation)
            }
        }
    }
    
    func didPanCamera(using panGesture: UIPanGestureRecognizer) {
        guard let cameraNode = rootNode.childNode(withName: Constants.Node.camera, recursively: true) else {
            return
        }
        
        guard let view = panGesture.view else { return }
        let translation = panGesture.translation(in: view)
        
        let xValue = translation.x * 0.002
        let yValue = translation.y * 0.002
        
        if panGesture.state == .changed {
            cameraNode.localTranslate(by: SCNVector3(-xValue, yValue, 0.0))
        }
    }
    
    // MARK: - Utilities
    
    private func daeToSCNNode(filepath: String) -> SCNNode? {
        // TODO: Move this to SCNNodeExtensions
        let scene = SCNScene(named: filepath)
        
        let childNodes = scene?.rootNode.childNodes
        
        for childNode in childNodes ?? [] {
            // TODO: Create a list of names that the child node has to compare to
            if childNode.name == "car" || childNode.name == "house" || childNode.name == "seaplane" {
                return childNode
            }
        }
        
        return nil
    }
    
}
