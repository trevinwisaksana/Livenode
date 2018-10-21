//
//  DelayAnimationAttributesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class DelayAnimationAttributesViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: DelayAnimationAttributesView = {
        let mainView = DelayAnimationAttributesView(delegate: self)
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
  
    
    // MARK: - Setup
    
    init(animationAttributes: DelayAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = "Delay"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - DelayAnimationAttributesViewDelegate

extension DelayAnimationAttributesViewController: DelayAnimationAttributesViewDelegate {
    func delayAnimationAttributesView(_ delayAnimationAttributesView: DelayAnimationAttributesView, didUpdateAnimationDelayDuration duration: TimeInterval, forAnimationAtIndex index: Int) {
        sceneEditorViewController().currentScene.didUpdateDelayAnimation(duration: duration, forAnimationAtIndex: index)
    }
    
    func delayAnimationAttributesView(_ delayAnimationAttributesView: DelayAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: DelayAnimationAttributes) {
        sceneEditorViewController().currentScene.addDelayAnimation(animation)
        dismiss(animated: true, completion: nil)
    }
    
    private func sceneEditorViewController() -> SceneEditorViewController {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        return sceneEditorViewController
    }
}
