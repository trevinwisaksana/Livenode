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
    
    // MARK: - Current Location
    
    private struct CurrentLocationState {
        static var currentLocation: SCNVector3 = SCNVector3Zero
    }
    
    public var currentLocation: SCNVector3 {
        get {
            return objc_getAssociatedObject(self, &CurrentLocationState.currentLocation) as? SCNVector3 ?? SCNVector3Zero
        }
        set {
            objc_setAssociatedObject(self, &CurrentLocationState.currentLocation, newValue, .OBJC_ASSOCIATION_RETAIN)
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
    
    public var targetLocation: SCNVector3 {
        get {
            return objc_getAssociatedObject(self, &TargetLocationState.targetLocation) as? SCNVector3 ?? SCNVector3Zero
        }
        set {
            objc_setAssociatedObject(self, &TargetLocationState.targetLocation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Current Angle
    
    private struct RotationAngleState {
        static var rotationAngle: CGFloat = 0.0
    }
    
    public var rotationAngle: CGFloat {
        get {
            return objc_getAssociatedObject(self, &RotationAngleState.rotationAngle) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &RotationAngleState.rotationAngle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
