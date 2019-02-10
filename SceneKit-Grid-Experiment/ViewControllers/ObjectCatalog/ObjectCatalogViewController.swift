//
//  ObjectCatalogViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class ObjectCatalogViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    private lazy var delegate = ObjectCatalogViewControllerDelegate()

    lazy var mainView: ObjectCatalogView = {
        let mainView = ObjectCatalogView(frame: view.frame, withDelegate: delegate)
        return mainView
    }()
    
    /// Pan gesture to detect scrolling.
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didBeginScrolling(_:)))
        return gestureRecognizer
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
        
        mainView.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - User Interaction

extension ObjectCatalogViewController {
    @objc
    private func didBeginScrolling(_ sender: UIPanGestureRecognizer) {
        mainView.didBeginScrolling(sender, inView: view)
    }
}
