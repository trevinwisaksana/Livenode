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
    
    init(animationAttributes: RotateAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = "Rotate"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - RotateAnimationAttributesViewDelegate

extension RotateAnimationAttributesViewController: RotateAnimationAttributesViewDelegate {
    func rotateAnimationAttributesView(_ rotateAniamtionAttributesView: RotateAnimationAttributesView, didUpdateAnimationDuration duration: Int) {
        
    }
    
    func rotateAnimationAttributesView(_ rotateAnimationAttributesView: RotateAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: RotateAnimationAttributes) {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        
        let angle = animation.angle ?? 0.0
        let duration = animation.duration ?? 0.0
        
        sceneEditorViewController.currentScene.addRotateAnimation(withAngle: angle, withDuration: duration)
        
        dismiss(animated: true, completion: nil)
    }
}
