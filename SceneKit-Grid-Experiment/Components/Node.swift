//
//  Node.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

// TODO: Create a savable version of SCNNode
class Node: NSObject, NSCoding {
    
    var color: UIColor? = .white
    var shape: SCNGeometry?
    
    // Location of object
    // Object color
    // Object shape
    //
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
}
