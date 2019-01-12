//
//  SCNNode+Movable.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

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
            // TODO: Fix issue where animation type cannot notice SCNActionSpeechBubble as .alert
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
        let newNode = self.clone()
        newNode.geometry = self.geometry?.copy() as? SCNGeometry
        newNode.geometry?.firstMaterial = self.geometry?.firstMaterial?.copy() as? SCNMaterial
        newNode.position = SCNVector3Zero
        
        return newNode
    }
    
}

extension SCNNode: NodeInspectorViewModel {

    // MARK: - Color
    
    public var color: UIColor {
        get {
            return self.geometry?.firstMaterial!.diffuse.contents as! UIColor
        }
    }
    
    public var angle: SCNVector3 {
        get {
            return self.eulerAngles
        }
    }
    
    public func changeColor(to color: UIColor) {
        self.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    // MARK: - Type
    
    public var type: NodeModel {
        get {
            switch self.geometry?.shape {
            case NodeType.SCNPlane.string:
                return .plane
            case NodeType.SCNBox.string:
                return .box
            case NodeType.SCNCar.string:
                return .car
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
    
}

// MARK: - Custom Node Classes

public class SCNCarNode: SCNNode {
    
    public init?(node: SCNNode?) {
        super.init()
        
        guard let node = node else {
            return nil
        }
        
        self.name = node.name
        
        let geometrySources = node.geometry?.sources ?? []
        let geometryElements = node.geometry?.elements ?? []
        self.geometry = SCNCar(sources: geometrySources, elements: geometryElements)
        self.geometry?.materials = node.geometry?.materials ?? []
        
        self.position = node.position
        self.scale = node.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
