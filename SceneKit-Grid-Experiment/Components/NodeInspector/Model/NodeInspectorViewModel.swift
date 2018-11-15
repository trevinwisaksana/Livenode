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
    var angle: SCNVector3 { get }
    var position: SCNVector3 { get }
    var type: NodeModel { get }
}

public struct NodeInspector: NodeInspectorViewModel {
    public var color: UIColor
    public var angle: SCNVector3
    public var position: SCNVector3
    public var type: NodeModel
}
