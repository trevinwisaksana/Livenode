//
//  NodeInspectorViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class NodeInspectorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: NodeInspectorPresentableView = {
        let mainView = NodeInspectorPresentableView(frame: .zero)
        mainView.delegate = self
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mainView.inspectorView.reloadData()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
}

// MARK: - NodeInspectorPresentableViewDelegate

extension NodeInspectorViewController: NodeInspectorPresentableViewDelegate {
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
    
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didUpdateNodePosition position: SCNVector3) {
        sceneEditorViewController().currentScene.changeNodePosition(to: position)
    }
    
    private func sceneEditorViewController() -> SceneEditorViewController {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        return sceneEditorViewController
    }
}
