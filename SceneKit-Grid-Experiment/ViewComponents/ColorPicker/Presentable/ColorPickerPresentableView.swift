//
//  ColorPickerPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 18/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class ColorPickerDataSource: NSObject {
    let node: Node? = State.nodeSelected
}

public class ColorPickerPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: ColorPickerDataSource = {
        return ColorPickerDataSource()
    }()
    
    
    
}
