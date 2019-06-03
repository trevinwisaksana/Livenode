//
//  SCNNode+Movable.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    /// Appends a list of nodes as a child node.
    @objc
    func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach { (node) in
            addChildNode(node)
        }
    }
    
}

extension SCNNode {
    
    // TODO: Make this savable
    
    // MARK: - Move
    
    private struct MovableState {
        static var isMovable = false
    }
    
    var isMovable: Bool {
        get {
            guard let movableState = objc_getAssociatedObject(self, &MovableState.isMovable) as? Bool else {
                return Bool()
            }
            
            return movableState
        }
        
        set(value) {
            objc_setAssociatedObject(self, &MovableState.isMovable, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Speech Bubble
    
    private struct SpeechBubbleState {
        static var willDisplaySpeechBubble = false
    }
    
    var willDisplaySpeechBubble: Bool {
        get {
            guard let speechBubbleState = objc_getAssociatedObject(self, &SpeechBubbleState.willDisplaySpeechBubble) as? Bool else {
                return Bool()
            }
            
            return speechBubbleState
        }
        
        set(value) {
            objc_setAssociatedObject(self, &SpeechBubbleState.willDisplaySpeechBubble, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Animations
    
    private struct ActionsState {
        static var actions = [SCNAction]()
    }
    
    public var actions: [SCNAction] {
        get {
            guard let cachedData = UserDefaults.standard.object(forKey: "\(name ?? "")-actions") as? Data
            else {
                return []
            }
            
            do {
                let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cachedData) as! [SCNAction]
                return unarchivedData
            } catch {
                fatalError("Failed to retrieve object catalog models.")
            }
        }
        set {
            do {
                let actionsData = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                UserDefaults.standard.set(actionsData, forKey: "\(name ?? "")-actions")
            } catch {
                fatalError("Cannot save object catalog models.")
            }
            
            objc_setAssociatedObject(self, &ActionsState.actions, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func addAction(_ action: SCNAction, forKey key: Animation) {
        actions.append(action)
    }
    
    func removeAllActions() {
        actions.removeAll()
    }
    
    func playAllAnimations(completionHandler: (() -> Void)?) {
        var actionSequence = [SCNAction]()

        actions.forEach { (action) in
            if action.animationType() == .speechBubble {
                let customAction = SCNAction.customAction(duration: action.duration) { (node, time) in
                    let alertNode = node.childNode(withName: Constants.Node.speechBubble, recursively: true)
                    alertNode?.runAction(action)
                }

                actionSequence.append(customAction)
            }
            
            actionSequence.append(action)
        }
        
        let sequence = SCNAction.sequence(actionSequence)
        runAction(sequence, completionHandler: completionHandler)
    }
    
    // MARK: - Duplicate
    
    public func duplicate() -> SCNNode {
        let newNode = clone()
        newNode.geometry = geometry?.copy() as? SCNGeometry
        newNode.geometry?.firstMaterial = geometry?.firstMaterial?.copy() as? SCNMaterial
        newNode.position = SCNVector3Zero
        
        return newNode
    }
    
}

extension SCNNode: NodeInspectorViewModel {

    // MARK: - Color
    
    public var color: UIColor {
        get {
            return geometry?.firstMaterial!.diffuse.contents as! UIColor
        }
    }
    
    private struct OriginalColorState {
        static var originalColor: UIColor?
    }
    
    public var originalColor: UIColor {
        get {
            guard let originalColorState = objc_getAssociatedObject(self, &OriginalColorState.originalColor) as? UIColor else {
                return UIColor.white
            }
            
            return originalColorState
        }
        
        set(value) {
            objc_setAssociatedObject(self, &OriginalColorState.originalColor, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func changeColor(to color: UIColor) {
        geometry?.firstMaterial?.diffuse.contents = color
        originalColor = color
    }
    
    /// Changes the node color to yellow to indicate it is selected
    public func highlight() {
        // Save the original color so it can be returned to normal when deselected
        originalColor = color
        
        geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
    }
    
    // MARK: - Type
    
    public var type: NodeModel {
        get {
            switch geometry?.name {
            case NodeType.SCNPlane.string:
                return .plane
                
            case NodeType.SCNBox.string:
                return .box
                
            case NodeType.SCNCar.string:
                return .car
                
            case NodeType.SCNSphere.string:
                return .sphere
                
            default:
                return .default
            }
        }
    }
    
    // MARK: - Size
    
    public var length: CGFloat? {
        get {
            return CGFloat(boundingBox.max.y - boundingBox.min.y)
        }
    }
    
    public var width: CGFloat? {
        get {
            return CGFloat(boundingBox.max.x - boundingBox.min.x)
        }
    }
    
    // MARK: - Position
    
    public var angle: SCNVector3 {
        get {
            return eulerAngles
        }
    }
    
}
