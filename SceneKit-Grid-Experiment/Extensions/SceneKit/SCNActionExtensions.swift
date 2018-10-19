//
//  SCNActionExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNAction {
    
    private struct AnimationTypeState {
        static var animationType: Animation = .default
    }
    
    public var animationType: Animation {
        get {
            return objc_getAssociatedObject(self, &AnimationTypeState.animationType) as? Animation ?? .default
        }
        set {
            objc_setAssociatedObject(self, &AnimationTypeState.animationType, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
