//
//  SceneInspectorViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public protocol SceneInspectorViewModel {
    var scene: Scene? { get }
}

public struct SceneInspector: SceneInspectorViewModel {
    public var scene: Scene?
}
