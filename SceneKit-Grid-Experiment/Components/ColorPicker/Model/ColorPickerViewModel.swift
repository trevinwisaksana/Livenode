//
//  ColorPickerViewModel.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

public protocol ColorPickerViewModel {
    var node: Node? { get }
}

public struct ColorPicker: ColorPickerViewModel {
    public var node: Node?
}


