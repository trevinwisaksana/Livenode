//
//  SCNActionExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNAction {
    
    // MARK: - Animation Type
    
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
    
    // MARK: - Target Location
    
    func move(to location: SCNVector3, duration: TimeInterval) -> SCNAction {
        let action = SCNAction.move(to: location, duration: duration)
        action.targetLocation = location
        
        return action
    }
    
    private struct TargetLocationState {
        static var targetLocation: SCNVector3 = SCNVector3Zero
    }
    
    private(set) var targetLocation: SCNVector3 {
        get {
            return objc_getAssociatedObject(self, &TargetLocationState.targetLocation) as? SCNVector3 ?? SCNVector3Zero
        }
        set {
            objc_setAssociatedObject(self, &TargetLocationState.targetLocation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Current Angle
    
    func rotate(by angle: CGFloat, around position: SCNVector3, duration: TimeInterval) -> SCNAction {
        let radians = angle * (CGFloat.pi / 180)
        let action = SCNAction.rotate(by: radians, around: position, duration: duration)
        action.rotationAngle = angle
        
        return action
    }
    
    private struct RotationAngleState {
        static var rotationAngle: CGFloat = 0.0
    }
    
    private(set) var rotationAngle: CGFloat {
        get {
            return objc_getAssociatedObject(self, &RotationAngleState.rotationAngle) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &RotationAngleState.rotationAngle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
