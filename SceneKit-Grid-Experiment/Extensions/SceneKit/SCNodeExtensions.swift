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
    
    func playAllAnimations() {
        let sequence = SCNAction.sequence(actions)
        runAction(sequence)
    }
    
}

extension SCNNode: NodeInspectorViewModel {

    // MARK: - Color
    
    public var color: UIColor {
        get {
            return self.geometry?.firstMaterial!.diffuse.contents as! UIColor
        }
    }
    
    public func changeColor(to color: UIColor) {
        self.geometry?.firstMaterial?.diffuse.contents = color
    }
    
}
