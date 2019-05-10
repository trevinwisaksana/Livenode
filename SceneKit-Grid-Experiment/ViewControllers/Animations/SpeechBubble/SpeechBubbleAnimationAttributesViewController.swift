//
//  AlertAnimationAttributesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class SpeechBubbleAnimationAttributesViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: SpeechBubbleAnimationAttributesView = {
        let mainView = SpeechBubbleAnimationAttributesView(delegate: self)
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    init(animationAttributes: SpeechBubbleAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = "Speech Bubble"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - AlertAnimationAttributesViewDelegate

extension SpeechBubbleAnimationAttributesViewController: SpeechBubbleAnimationAttributesViewDelegate {
    func speechBubbleAnimationAttributesView(_ alertAnimationAttributesView: SpeechBubbleAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: SpeechBubbleAnimationAttributes) {
        
        sceneEditorViewController().didTapAddSpeechBubbleAnimationButton(button, animation: animation)
        
        dismiss(animated: true, completion: nil)
    }
    
    func speechBubbleAnimationAttributesView(_ alertAnimationAttributesView: SpeechBubbleAnimationAttributesView, speechBubbleTitle title: String, forAnimationAtIndex index: Int) {
        
        // TODO: Get this to transfer the title to the DefaultScene
    }
    
    private func sceneEditorViewController() -> SceneEditorViewController {
        let rootNavigationController = presentingViewController as! RootNavigationController
        let sceneEditorViewController = rootNavigationController.viewControllers.first as! SceneEditorViewController
        
        return sceneEditorViewController
    }
}
