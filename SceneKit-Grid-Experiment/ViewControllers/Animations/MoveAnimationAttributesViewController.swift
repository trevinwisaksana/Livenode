//
//  MoveAnimationAttributesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class MoveAnimationAttributesViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: MoveAnimationAttributesView = {
        let mainView = MoveAnimationAttributesView(delegate: self)
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideMoveAnimationTargetLocation()
    }
    
    // MARK: - Setup
    
    init(animationAttributes: MoveAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        displayMoveAnimationTargetLocation()
        
        title = "Move"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - MoveAnimationAttributesViewController

extension MoveAnimationAttributesViewController: MoveAnimationAttributesViewDelegate {
    func moveAnimationAttributesView(_ moveAnimationAttributesView: MoveAnimationAttributesView, didUpdateAnimationLocation location: SCNVector3, forAnimationAtIndex index: Int) {
        sceneEditorViewController().currentScene.didUpdateMoveAnimationLocation(location, forAnimationAtIndex: index)
    }
    
    func moveAnimationAttributesView(_ moveAnimationAttributesView: MoveAnimationAttributesView, didUpdateAnimationDuration duration: TimeInterval, forAnimationAtIndex index: Int) {
        sceneEditorViewController().currentScene.didUpdateAnimationDuration(duration, forAnimationAtIndex: index)
    }
    
    private func sceneEditorViewController() -> SceneEditorViewController {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        return sceneEditorViewController
    }
}

// MARK: - MoveAnimationTargetLocation

extension MoveAnimationAttributesViewController {
    private func displayMoveAnimationTargetLocation() {
        guard let location = mainView.dataSource?.targetLocation else { return }
        sceneEditorViewController().currentScene.displayMoveAnimationTargetLocation(location)
    }
    
    private func hideMoveAnimationTargetLocation() {
        sceneEditorViewController().currentScene.hideMoveAnimationTargetLocation()
    }
}
