//
//  ModelAnimationAttributesModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol MoveAnimationAttributesViewModel {
    var targetLocation: SCNVector3 { get }
}

public struct MoveAnimationAttributes:  MoveAnimationAttributesViewModel, AnimationDurationModel {
    public var duration: TimeInterval?
    public var targetLocation: SCNVector3
}