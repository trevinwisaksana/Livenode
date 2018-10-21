//
//  RotateAnimationAttributesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class RotateAnimationAttributesViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: RotateAnimationAttributesView = {
        let view = RotateAnimationAttributesView(delegate: self)
        return view
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Setup
    
    init(animationAttributes: RotateAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = "Rotate"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - RotateAnimationAttributesViewDelegate

extension RotateAnimationAttributesViewController: RotateAnimationAttributesViewDelegate {
    func rotateAnimationAttributesView(_ rotateAnimationAttributesView: RotateAnimationAttributesView, didUpdateAnimationRotationAngle angle: CGFloat, forAnimationAtIndex index: Int) {
        sceneEditorViewController().currentScene.didUpdateRotateAnimation(angle: angle, forAnimationAtIndex: index)
    }
    
    func rotateAnimationAttributesView(_ rotateAniamtionAttributesView: RotateAnimationAttributesView, didUpdateAnimationDuration duration: TimeInterval, forAnimationAtIndex index: Int) {
        sceneEditorViewController().currentScene.didUpdateAnimationDuration(duration, forAnimationAtIndex: index)
    }
    
    func rotateAnimationAttributesView(_ rotateAnimationAttributesView: RotateAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: RotateAnimationAttributes) {
        sceneEditorViewController().currentScene.addRotateAnimation(animation)
        dismiss(animated: true, completion: nil)
    }
    
    private func sceneEditorViewController() -> SceneEditorViewController {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        return sceneEditorViewController
    }
}
