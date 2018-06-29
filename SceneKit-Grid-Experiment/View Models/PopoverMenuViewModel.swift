//
//  PopoverMenuViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SceneKit

struct PopoverMenuViewModel {
    
    var nodeSelected: SCNNode?
    
    func removeNode() {
        guard let nodeSelected = nodeSelected else {
            return
        }
        
        nodeSelected.removeFromParentNode()
    }
    
    func makeNodeMovable() {
        guard let nodeSelected = nodeSelected else {
            return
        }
        
        nodeSelected.isMovable = true
    }
    
}
