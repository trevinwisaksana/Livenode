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
    
}

public class SceneInspectorPresentableView: UIView {
    lazy var dataSource: SceneDataSource = {
        return SceneDataSource()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = SceneInspectorView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
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

        guard let parentController = self.parentViewController?.parent else {
            return
        }

        switch indexPath.row {
        case 0:
            let viewController = Presenter.inject(.colorPickerView)
            viewController.modalPresentationStyle = .popover
            parentController.present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    private func present() {
        
    }
}

// MARK: - SceneInspectorViewDataSource

extension SceneInspectorPresentableView: SceneInspectorViewDataSource {
    public func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, sceneBackgroundColor for: SCNScene) -> UIColor {
        return .green
    }
}
