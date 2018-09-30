//
//  SceneEditorView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 23/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class SceneEditorView: UIView {
    
    // MARK: - Internal Properties
    
    private var sceneView: SCNView = {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        return sceneView
    }()
    
    // MARK: - Setup
    
    public init(delegate: SceneActionsMenuViewDelegate, dataSource: SceneActionsMenuViewDataSource) {
        super.init(frame: .zero)
        
//        self.delegate = delegate
//        self.dataSource = dataSource
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
      
    }
    
}
