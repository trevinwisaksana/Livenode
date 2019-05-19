//
//  PresentationMainView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 12/05/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

final class PresentationMainView: UIView {
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    private let feedbackViewWidth: CGFloat = 750.0
    private let feedbackViewHeight: CGFloat = 35.0
    private let feedbackViewBottomMargin: CGFloat = -30.0
    
    lazy var sceneView: ARSCNView = {
        let view = ARSCNView(frame: .zero)
        view.autoenablesDefaultLighting = true
        return view
    }()
    
    lazy var feedbackView: SurfaceDetectionFeedbackView = {
        let view = SurfaceDetectionFeedbackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var onboardingView: PresentationOnboardingView = {
        let onboardingView = PresentationOnboardingView(frame: frame)
        onboardingView.delegate = self
        return onboardingView
    }()
    
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sceneView)
        sendSubviewToBack(sceneView)
        
        addSubview(feedbackView)
        
        if UserDefaults.standard.bool(forKey: Constants.UserState.didDisplayPresentationOnboarding) {
            prepareScene()
            setupARTracker()
        } else {
            addSubview(onboardingView)
            onboardingView.fillInSuperview()
        }
        
        backgroundColor = .black
        
        NSLayoutConstraint.activate([
            feedbackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            feedbackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: feedbackViewBottomMargin),
            feedbackView.widthAnchor.constraint(lessThanOrEqualToConstant: feedbackViewWidth),
            feedbackView.heightAnchor.constraint(greaterThanOrEqualToConstant: feedbackViewHeight),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareScene() {
        guard let scene = NodePresentationManager.currentScene else { fatalError("Failed to initialize scene.") }
        sceneView.prepare([scene], completionHandler: { _ in
            self.sceneView.fillInSuperview()
        })
    }
    
    func setupARTracker() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
    }
    
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func adjustSpeechBubbleAngle(on eulerAngles: simd_float3, from view: ARSCNView) {
        guard let speechBubbleNode = view.scene.rootNode.childNode(withName: Constants.Node.speechBubble, recursively: true) else {
            return
        }
        
        speechBubbleNode.eulerAngles.x = eulerAngles.x
        speechBubbleNode.eulerAngles.y = eulerAngles.y
    }
    
}

// MARK: - OnboardingViewDelegate

extension PresentationMainView: PresentationOnboardingViewDelegate {
    func didTapContinueButton(_ sender: PresentationOnboardingView) {
        prepareScene()
        setupARTracker()
    }
}
