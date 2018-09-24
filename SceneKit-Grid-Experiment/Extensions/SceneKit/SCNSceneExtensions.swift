//
//  SCNScene+BackgroundColor.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNScene {
    
    public var backgroundColor: UIColor {
        get {
            return background.contents as! UIColor
        }
        set {
            background.contents = newValue
        }
    }
    
}

// TODO: Change this to make the floorNode property editable
//extension SCNScene: SceneProtocol {
//
//    var floorNode: SCNNode? {
//        get {
//            return floorNode
//        }
//    }
//
//}

