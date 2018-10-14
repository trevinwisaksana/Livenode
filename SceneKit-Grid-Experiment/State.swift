//
//  State.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

struct State {    
    static var currentDocument: SceneDocument?
    static var isEditingScene: Bool = false
    static var nodeSelected: SCNNode?
}
