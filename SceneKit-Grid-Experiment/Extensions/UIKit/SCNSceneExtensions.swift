//
//  SCNScene+BackgroundColor.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

extension SCNScene {
    
    var backgroundColor: UIColor {
        get {
            return self.background.contents as! UIColor
        }
    }
    
}

