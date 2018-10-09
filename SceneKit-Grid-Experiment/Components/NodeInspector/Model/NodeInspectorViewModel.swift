//
//  NodeInspectorViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public protocol NodeInspectorViewModel {
    var color: UIColor { get }
}

public struct NodeInspector: NodeInspectorViewModel {
    public var color: UIColor
}
