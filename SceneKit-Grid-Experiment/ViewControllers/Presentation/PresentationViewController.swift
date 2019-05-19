//
//  PresentationViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

protocol PresentationARSessionDelegate: class {
    
}

final class PresentationViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private lazy var manager = NodePresentationManager()
    
    lazy var mainView: PresentationMainView = {
        let mainView = PresentationMainView(frame: view.frame)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToDismiss(_:)))
        mainView.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNodesToSceneView(_:)))
        mainView.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        mainView.sceneView.session.delegate = self
        
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mainView.sceneView.session.pause()
    }
    
    // MARK: - Setup
    
    init(scene: DefaultScene) {
        super.init(nibName: nil, bundle: nil)
        
        NodePresentationManager.currentScene = scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view = mainView
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - User Interaction
    
    @objc
    private func didPinchToDismiss(_ sender: UIPinchGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func addNodesToSceneView(_ recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: mainView.sceneView)
        let hitTestResults = mainView.sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else {
            return
        }
        
        let position = hitTestResult.worldTransform.columns.3
        
        manager.addPresentingNode(to: mainView.sceneView, at: position)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

// MARK: - ARSessionDelegate

extension PresentationViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        mainView.adjustSpeechBubbleAngle(on: frame.camera.eulerAngles, from: mainView.sceneView)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        DispatchQueue.main.async {
            self.mainView.feedbackView.updateFeedbackLabel(for: frame, trackingState: frame.camera.trackingState)
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        DispatchQueue.main.async {
            self.mainView.feedbackView.updateFeedbackLabel(for: frame, trackingState: frame.camera.trackingState)
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async {
            self.mainView.feedbackView.updateFeedbackLabel(for: session.currentFrame!, trackingState: camera.trackingState)
        }
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        DispatchQueue.main.async {
            self.mainView.feedbackView.sessionWasInterruptedLabel()
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            // Reset tracking and/or remove existing anchors if consistent tracking is required.
            self.mainView.feedbackView.feedbackLabel.text = "Session interruption ended"
            self.mainView.resetTracking()
        }   
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
        DispatchQueue.main.async {
            self.mainView.feedbackView.feedbackLabel.text = "Session failed: \(error.localizedDescription)"
        }
        
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                if errorMessage.contains("Unsupported configuration") {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                
                alertController.dismiss(animated: true, completion: nil)
                self.mainView.resetTracking()
            }
            
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
