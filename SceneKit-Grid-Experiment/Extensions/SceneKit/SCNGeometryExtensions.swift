//
//  SCNGeometryExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNGeometry {
    
    var shape: String {
        return String(describing: type(of: self))
    }
    
}

// MARK: - Custom Geometry Classes

public class SCNCar: SCNGeometry {}
