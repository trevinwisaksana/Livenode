//
//  SceneInspectorDemoView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class SceneDataSource: NSObject {
    let scene: Scene? = State.currentDocument?.scene
}

public class SceneInspectorPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: SceneDataSource = {
        return SceneDataSource()
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = SceneInspectorView(delegate: self, dataSource: self)
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - Scene Inspector View Delegate

extension SceneInspectorPresentableView: SceneInspectorViewDelegate {
    public func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, didSelectItemAtIndexPath indexPath: IndexPath) {
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

// MARK: - SceneInspectorViewDataSource

extension SceneInspectorPresentableView: SceneInspectorViewDataSource {
    public func viewModel(inSceneInspectorView sceneInspectorView: SceneInspectorView) -> SceneInspectorViewModel {
        return SceneInspector(scene: dataSource.scene)
    }
}
