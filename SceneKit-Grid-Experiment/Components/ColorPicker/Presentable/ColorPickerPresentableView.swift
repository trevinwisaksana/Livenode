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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = ColorPickerView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
    
}

// MARK: - ColorPickerViewDelegate

extension ColorPickerPresentableView: ColorPickerViewDelegate {
    public func didTap(color: UIColor) {
        NotificationCenter.default.post(name: Constants.NotificationCenter.nodeColorModifiedKey, object: color)
    }
}

// MARK: - ColorPickerViewDataSource

extension ColorPickerPresentableView: ColorPickerViewDataSource {
    public func viewModel(InColorPickerView colorPickerView: ColorPickerView) -> ColorPickerViewModel {
        return ColorPicker(node: dataSource.node)
    }
}
