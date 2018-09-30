//
//  SceneActionsMenuPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class SceneActionsMenuDataSource: NSObject {
    let nodeSelected: Node? = State.nodeSelected
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
    public func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectDeleteFor node: SCNNode) {
        
    }
    
    public func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectMoveFor node: SCNNode) {
        
    }
    
    public func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectCopyFor node: SCNNode) {
        
    }
    
    public func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectPasteFor node: SCNNode) {
        
    }
}

// MARK: - SceneActionsMenuViewDataSource

extension SceneActionsMenuPresentableView: SceneActionsMenuViewDataSource {
    public func viewModel(InSceneActionsMenuView sceneActionsMenuView: SceneActionsMenuView) -> SceneActionsMenuViewModel {
        return SceneActionsMenu()
    }
}
