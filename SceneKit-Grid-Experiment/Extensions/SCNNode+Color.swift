//
//  SCNNode+Color.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    public func change(color: UIColor) {
        self.geometry?.firstMaterial?.diffuse.contents = color
    }
    
}
