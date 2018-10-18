//
//  RotateAnimationAttributesModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 18/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol RotateAnimationAttributesViewModel {
    var duration: TimeInterval? { get }
    var angle: CGFloat? { get }
}

public struct RotateAnimationAttributes: RotateAnimationAttributesViewModel {
    public var duration: TimeInterval?
    public var angle: CGFloat?
}
