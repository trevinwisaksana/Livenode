//
//  SurfaceFeedbackWarningView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ARKit

public class SurfaceDetectionFeedbackView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // MARK - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(feedbackLabel)
        
        backgroundColor = .yellow
        layer.cornerRadius = Style.containerCornerRadius
        
        NSLayoutConstraint.activate([
            feedbackLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            feedbackLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Feedback Labels
    
    func updateFeedbackLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move the device around to detect horizontal and vertical surfaces."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
        }
        
        feedbackLabel.text = message
    }
    
    func sessionWasInterruptedLabel() {
        feedbackLabel.text = "Session was interrupted"
    }
    
}
