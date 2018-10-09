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
    
    // MARK: - Highlight
    
    private struct HighlightState {
        static var isHighlighted = false
    }
    
    var isHighlighted: Bool {
        get {
            guard let highlightState = objc_getAssociatedObject(self, &HighlightState.isHighlighted) as? Bool else {
                return Bool()
            }
            
            return highlightState
        }
        
        set(value) {
            objc_setAssociatedObject(self, &HighlightState.isHighlighted, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
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
