//
//  UtilitiesViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 03/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

public protocol UtilitiesViewModel {
    var scene: Scene? { get }
}

public struct Utilities: UtilitiesViewModel {
    public var scene: Scene?
}
