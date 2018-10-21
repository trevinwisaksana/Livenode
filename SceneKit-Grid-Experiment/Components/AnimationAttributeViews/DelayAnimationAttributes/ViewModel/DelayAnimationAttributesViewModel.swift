//
//  DelayAnimationAttributesViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol DelayAnimationAttributesViewModel {
    var animationIndex: Int? { get }
}

public struct DelayAnimationAttributes: DelayAnimationAttributesViewModel, AnimationDurationViewModel {
    public var duration: TimeInterval?
    public var animationIndex: Int?
}

