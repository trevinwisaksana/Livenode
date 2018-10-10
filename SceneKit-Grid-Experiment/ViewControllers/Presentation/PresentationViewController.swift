//
//  PresentationViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

final class PresentationViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    private var sceneView: ARSCNView = {
        let view = ARSCNView(frame: .zero)
        return view
    }()
    
    // MARK: - Public Properties
    
    public var delegate = PresentationViewControllerDelegate()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        createARSession()
    }
    
    // MARK: - Setup
    
    private func setup() {
        // TODO: Create a method in DefaultScene that would prepare for AR usage
        guard let scene = State.currentDocument?.scene else {
            return
        }
        
        sceneView.delegate = delegate
        sceneView.scene = scene
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToDismiss(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func createARSession() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: .resetTracking)
    }
    
    @objc
    private func didPinchToDismiss(_ sender: UIPinchGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
