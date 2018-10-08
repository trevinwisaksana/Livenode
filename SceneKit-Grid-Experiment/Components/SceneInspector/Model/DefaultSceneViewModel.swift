//
//  DefaultSceneViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol DefaultSceneViewModel {
    var backgroundColor: UIColor { get }
    var floorColor: UIColor? { get }
}
