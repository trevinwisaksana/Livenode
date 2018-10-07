//
//  SceneInspectorViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public protocol SceneInspectorViewModel {
    var backgroundColor: UIColor? { get set }
    var floorColor: UIColor? { get set }
}

public struct SceneInspector: SceneInspectorViewModel {
    public var backgroundColor: UIColor?
    public var floorColor: UIColor?
}
