//
//  UtilitiesPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 03/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class UtilitiesDataSource: NSObject {
    let scene: Scene? = State.currentScene
}

public class UtilitiesPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: UtilitiesDataSource = {
        return UtilitiesDataSource()
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = UtilitiesView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - UtilitiesViewDelegate

extension UtilitiesPresentableView: UtilitiesViewDelegate {
    public func utilitiesView(_ utilitiesView: UtilitiesView, didSelectItemAtIndexPath indexPath: IndexPath) {
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
extension UtilitiesPresentableView: UtilitiesViewDataSource {
    public func viewModel(InColorPickerView colorPickerView: UtilitiesView) -> UtilitiesViewModel {
        return Utilities(scene: dataSource.scene)
    }
}

