//
//  SCNNode+Movable.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNNode {
    
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
            return objc_getAssociatedObject(self, &ActionsState.actions) as? [SCNAction] ?? []
        }
        set {
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
            if action.animationType == .alert {
                let customAction = SCNAction.customAction(duration: action.duration) { (node, time) in
                    let alertNode = node.childNode(withName: "AlertNode", recursively: true)
                    alertNode?.runAction(action)
                }

                actionSequence.append(customAction)
            }
            
            actionSequence.append(action)
        }
        
        let sequence = SCNAction.sequence(actionSequence)
        runAction(sequence, completionHandler: completionHandler)
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
    
}
