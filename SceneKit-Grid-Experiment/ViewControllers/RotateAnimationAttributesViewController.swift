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
    
    lazy var mainView: RotateAniamtionAttributesView = {
        let view = RotateAniamtionAttributesView(delegate: self)
        return view
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - RotateAnimationAttributesViewDelegate

extension RotateAnimationAttributesViewController: RotateAnimationAttributesViewDelegate {
    func rotateAniamtionAttributesView(_ rotateAniamtionAttributesView: RotateAniamtionAttributesView, didUpdateAnimationDuration duration: Int) {
        
    }
    
    func rotateAniamtionAttributesView(_ rotateAniamtionAttributesView: RotateAniamtionAttributesView, didTapAddAnimationButton button: UIButton) {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        // TODO: Make this method send a struct of animation data
        sceneEditorViewController.currentScene.addRotateAnimation(withAngle: 90, withDuration: 2)
        dismiss(animated: true, completion: nil)
    }
}
