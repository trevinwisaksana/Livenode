//
//  PopoverMenuViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SceneKit

class PopoverMenuViewModel {
    
    var selectedNode: SCNNode?
    
    func removeNode() {
        guard let selectedNode = selectedNode else {
            return
        }
        
        selectedNode.removeFromParentNode()
    }
    
    func makeNodeMovable() {
        guard let selectedNode = selectedNode else {
            return
        }
        
        selectedNode.isMovable = true
    }
    
}
