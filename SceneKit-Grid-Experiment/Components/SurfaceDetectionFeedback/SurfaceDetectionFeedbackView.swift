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
    
    private let feedbackLabelLeftMargin: CGFloat = 8.0
    private let feedbackLabelRightMargin: CGFloat = -8.0
    private let feedbackLabelTopMargin: CGFloat = 2.0
    private let feedbackLabelBottomMargin: CGFloat = -2.0
    
    lazy var feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
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
            feedbackLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: feedbackLabelLeftMargin),
            feedbackLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: feedbackLabelRightMargin),
            feedbackLabel.topAnchor.constraint(equalTo: topAnchor, constant: feedbackLabelTopMargin),
            feedbackLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: feedbackLabelBottomMargin),
        ])
    }
    
    // MARK: - Feedback Labels
    
    func updateFeedbackLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            message = "Move the device around to detect horizontal and vertical surfaces."
            
        case .normal:
//            message = "Tap on the screen to insert the 3D models."
            message = ""
            
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
            message = ""
        }
        
        feedbackLabel.text = message
        isHidden = message.isEmpty
    }
    
    func sessionWasInterruptedLabel() {
        feedbackLabel.text = "Session was interrupted"
    }
    
}
