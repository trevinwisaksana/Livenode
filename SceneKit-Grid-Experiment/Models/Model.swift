//
//  Model.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

enum Model: String {
    case box
    case pyramid
    
    var filename: String {
        return self.rawValue.capitalized + ".scn"
    }
}
