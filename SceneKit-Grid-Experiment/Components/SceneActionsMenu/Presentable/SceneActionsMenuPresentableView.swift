//
//  SceneActionsMenuPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class SceneActionsMenuDataSource: NSObject {
    
}

public class SceneActionsMenuPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: SceneActionsMenuDataSource = {
        return SceneActionsMenuDataSource()
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = SceneActionsMenuView(delegate: self, dataSource: self)
        addSubview(view)
        view.fillInSuperview()
    }
    
}

// MARK: - SceneActionsMenuViewDelegate

extension SceneActionsMenuPresentableView: SceneActionsMenuViewDelegate {
    public func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
}

// MARK: - SceneActionsMenuViewDataSource

extension SceneActionsMenuPresentableView: SceneActionsMenuViewDataSource {
    public func viewModel(InSceneActionsMenuView sceneActionsMenuView: SceneActionsMenuView) -> SceneActionsMenuViewModel {
        return SceneActionsMenu()
    }
}
