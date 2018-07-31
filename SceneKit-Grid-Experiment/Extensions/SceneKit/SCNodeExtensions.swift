//
//  SCNNode+Movable.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    private struct MovableState {
        static var isMovable = false
    }
    
    // MARK: - Move
    
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
    
    // MARK: - Color
    
    var color: UIColor {
        get {
            return self.geometry?.firstMaterial!.diffuse.contents as! UIColor
        }
    }
    
    public func change(color: UIColor) {
        self.geometry?.firstMaterial?.diffuse.contents = color
    }
    
}
