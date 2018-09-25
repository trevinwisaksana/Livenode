//
//  UtilitiesPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 03/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class UtilitiesInspectorDataSource: NSObject {
    let scene: Scene? = State.currentScene
}

public class UtilitiesInspectorPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: UtilitiesInspectorDataSource = {
        return UtilitiesInspectorDataSource()
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = UtilitiesInspectorView(delegate: self, dataSource: self)
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - UtilitiesViewDelegate

extension UtilitiesInspectorPresentableView: UtilitiesInspectorViewDelegate {
    public func utilitiesView(_ utilitiesView: UtilitiesInspectorView, didSelectItemAtIndexPath indexPath: IndexPath) {
        transition(using: indexPath)
    }

    private func transition(using indexPath: IndexPath) {
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }
        
        switch indexPath.row {
        case 0:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController.pushViewController(colorPicker, animated: true)
        case 1:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController.pushViewController(colorPicker, animated: true)
        default:
            break
        }
    }
}

// MARK: - UtilitiesViewDataSource

// NOTE: Not sure if this is necessary
extension UtilitiesInspectorPresentableView: UtilitiesInspectorViewDataSource {
    public func viewModel(InColorPickerView colorPickerView: UtilitiesInspectorView) -> UtilitiesInspectorViewModel {
        return Utilities(scene: dataSource.scene)
    }
}

