//
//  SceneInspectorDemoView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class SceneDataSource: NSObject {
    // TODO: Add View Model
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
        transition(fromSection: indexPath.section)
    }
    
    private func transition(fromSection section: Int) {
        let viewController: UIViewController
        
        switch section {
        case 0:
            break
        default:
            break
        }
    }
}

// MARK: - Scene Inspector Data Source

extension SceneInspectorPresentableView: SceneInspectorViewDataSource {
    public func numberOfItems(inSceneInspectorView sceneInspectorView: SceneInspectorView) -> Int {
        return 1
    }
}
