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
    
    private let feedbackViewWidth: CGFloat = 750.0
    private let feedbackViewHeight: CGFloat = 35.0
    private let feedbackViewBottomMargin: CGFloat = -30.0
    
    private var sceneView: ARSCNView = {
        let view = ARSCNView(frame: .zero)
        view.autoenablesDefaultLighting = true
        return view
    }()
    
    private var feedbackView: SurfaceDetectionFeedbackView = {
        let view = SurfaceDetectionFeedbackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var onboardingView: PresentationOnboardingView = {
        let onboardingView = PresentationOnboardingView(frame: view.frame)
        onboardingView.delegate = self
        return onboardingView
    }()
    
    private lazy var manager = NodePresentationManager()
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupARTracker()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sceneView.session.pause()
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
        view.addSubview(sceneView)
        view.sendSubviewToBack(sceneView)
        
        view.addSubview(feedbackView)
        
        view.addSubview(onboardingView)
        onboardingView.fillInSuperview()
        
        guard let scene = NodePresentationManager.currentScene else { fatalError("Failed to initialize scene.") }
        sceneView.prepare([scene], completionHandler: nil)
        sceneView.fillInSuperview()
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToDismiss(_:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNodesToSceneView(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NSLayoutConstraint.activate([
            feedbackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: feedbackViewBottomMargin),
            feedbackView.widthAnchor.constraint(lessThanOrEqualToConstant: feedbackViewWidth),
            feedbackView.heightAnchor.constraint(greaterThanOrEqualToConstant: feedbackViewHeight),
        ])
    }
    
    private func setupARTracker() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.session.delegate = self
        
        UIApplication.shared.isIdleTimerDisabled = true
    }

    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
            return
        }
        
        let position = hitTestResult.worldTransform.columns.3
        
        manager.addPresentingNode(to: sceneView, at: position)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

// MARK: - ARSessionDelegate

extension PresentationViewController: ARSessionDelegate {
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        DispatchQueue.main.async {
            self.feedbackView.updateFeedbackLabel(for: frame, trackingState: frame.camera.trackingState)
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        DispatchQueue.main.async {
            self.feedbackView.updateFeedbackLabel(for: frame, trackingState: frame.camera.trackingState)
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async {
            self.feedbackView.updateFeedbackLabel(for: session.currentFrame!, trackingState: camera.trackingState)
        }
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        DispatchQueue.main.async {
            self.feedbackView.sessionWasInterruptedLabel()
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            // Reset tracking and/or remove existing anchors if consistent tracking is required.
            self.feedbackView.feedbackLabel.text = "Session interruption ended"
            self.resetTracking()
        }   
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        feedbackView.feedbackLabel.text = "Session failed: \(error.localizedDescription)"
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
                self.resetTracking()
            }
            
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - OnboardingViewDelegate

extension PresentationViewController: PresentationOnboardingViewDelegate {
    func didTapContinueButton(_ sender: PresentationOnboardingView) {
        sender.removeFromSuperview()
    }
}
