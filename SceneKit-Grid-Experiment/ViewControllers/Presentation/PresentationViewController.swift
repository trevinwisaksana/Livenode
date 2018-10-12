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
    
    private var currentScene: DefaultScene?
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO: Fix issue where scene is reset after dismissing view controller
        sceneView.session.pause()
    }
    
    // MARK: - Setup
    
    init(scene: DefaultScene) {
        super.init(nibName: nil, bundle: nil)
        
        currentScene = scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        sceneView.delegate = delegate
        view.addSubview(sceneView)
        sceneView.fillInSuperview()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToDismiss(_:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNodesToSceneView(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func createARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: .resetTracking)
    }
    
    // MARK: - User Interaction
    
    @objc
    private func didPinchToDismiss(_ sender: UIPinchGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func addNodesToSceneView(_ recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else {
            print("Cannot detect surface.")
            return
        }
        
        let translation = hitTestResult.worldTransform.columns.3
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        guard let defaultScene = currentScene,
              let presentationNodes = defaultScene.rootNode.childNode(withName: "presentationNodeContainer", recursively: true)
        else {
            // TODO: Fix issue which deletes the nodes when retrieving it from the rootNode
            print("Cannot find the presentation node container.")
            return
        }
        
        presentationNodes.position = SCNVector3(x, y, z)
        presentationNodes.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(presentationNodes)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
