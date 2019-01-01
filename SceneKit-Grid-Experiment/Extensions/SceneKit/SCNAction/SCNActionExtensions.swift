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
    
    func animationType() -> Animation {
        switch String(describing: type(of: self)) {
        case AnimationType.SCNActionMove.string:
            return .move
        case AnimationType.SCNActionRotate.string:
            return .rotate
        case AnimationType.SCNActionWait.string:
            return .delay
        case AnimationType.SCNActionFade.string:
            return .speechBubble
        default:
            return .default
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
    
    func rotate(by angle: CGFloat, aroundAxis axis: SCNVector3, duration: TimeInterval) -> SCNAction {
        let radians = angle * (CGFloat.pi / 180)
        
        let yAxis = SCNVector3(0, 1, 0)
        let action = SCNAction.rotate(by: radians, around: yAxis, duration: duration)
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
    
    // MARK: - Delay
    
    func wait(duration: TimeInterval) -> SCNAction {
        let action = SCNAction.wait(duration: duration)
        action.delayDuration = duration
        
        return action
    }
    
    private struct DelayState {
        static var delayDuration: TimeInterval = 0.0
    }
    
    private(set) var delayDuration: TimeInterval {
        get {
            return objc_getAssociatedObject(self, &DelayState.delayDuration) as? TimeInterval ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &DelayState.delayDuration, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Speech Bubble Animation
    
    class func speechBubble(caption: String) -> SCNAction {
        return SCNActionSpeechBubble()
    }
    
}
