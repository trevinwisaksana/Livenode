//
//  ColorPickerViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol ColorPickerViewModel {
    var color: UIColor? { get }
}

public struct ColorPicker: ColorPickerViewModel {
    public var color: UIColor?
}


