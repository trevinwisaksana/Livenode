//
//  SpeechBubbleAnimationAttributesViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public protocol SpeechBubbleAnimationAttributesViewModel {
    var nodeLocation: SCNVector3? { get }
    var animationIndex: Int? { get }
}

public struct SpeechBubbleAnimationAttributes: SpeechBubbleAnimationAttributesViewModel, AnimationDurationViewModel {
    public var duration: TimeInterval?
    public var animationIndex: Int?
    public var nodeLocation: SCNVector3?
}
