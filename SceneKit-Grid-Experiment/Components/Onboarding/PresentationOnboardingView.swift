//
//  PresentationOnboardingView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/04/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol PresentationOnboardingViewDelegate: class {
    func didTapContinueButton(_ sender: PresentationOnboardingView)
}

final class PresentationOnboardingView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var scanSurfaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan a Surface"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "SFProDisplay-Regular", size: 22)
        return label
    }()
    
    lazy var showModelLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to show your model"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "SFProDisplay-Regular", size: 22)
        return label
    }()
    
    lazy var pinchToExitLabel: UILabel = {
        let label = UILabel()
        label.text = "Pinch to exit"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "SFProDisplay-Regular", size: 22)
        return label
    }()
    
    lazy var scanSurfaceArtworkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .scanOnboardingArtwork))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var showModelArtworkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .tapOnboardingArtwork))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var pinchToExitArtworkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .pinchOnboardingArtwork))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.lavender, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 22)
        button.addTarget(self, action: #selector(didTapContinueButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        return containerView
    }()
    
    lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = .black
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()
    
    private let titleLabelSideMargin: CGFloat = 90.0
    private let titleLabelTopMargin: CGFloat = 90.0
    
    weak var delegate: PresentationOnboardingViewDelegate?
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(containerView)
        
        addSubview(overlayView)
        overlayView.fillInSuperview()
        sendSubviewToBack(overlayView)
        
        containerView.addSubview(scanSurfaceLabel)
        containerView.addSubview(showModelLabel)
        containerView.addSubview(pinchToExitLabel)
        containerView.addSubview(scanSurfaceArtworkImageView)
        containerView.addSubview(showModelArtworkImageView)
        containerView.addSubview(pinchToExitArtworkImageView)
        containerView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 150),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -150),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            showModelArtworkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            showModelArtworkImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            showModelArtworkImageView.widthAnchor.constraint(equalToConstant: 200),
            showModelArtworkImageView.heightAnchor.constraint(equalToConstant: 100),
            
            showModelLabel.centerYAnchor.constraint(equalTo: showModelArtworkImageView.centerYAnchor, constant: -90),
            showModelLabel.centerXAnchor.constraint(equalTo: showModelArtworkImageView.centerXAnchor),
            
            scanSurfaceArtworkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            scanSurfaceArtworkImageView.rightAnchor.constraint(equalTo: showModelArtworkImageView.leftAnchor, constant: -70),
            scanSurfaceArtworkImageView.widthAnchor.constraint(equalToConstant: 200),
            scanSurfaceArtworkImageView.heightAnchor.constraint(equalToConstant: 100),
            
            scanSurfaceLabel.centerYAnchor.constraint(equalTo: showModelLabel.centerYAnchor),
            scanSurfaceLabel.centerXAnchor.constraint(equalTo: scanSurfaceArtworkImageView.centerXAnchor),
            
            pinchToExitArtworkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pinchToExitArtworkImageView.leftAnchor.constraint(equalTo: showModelArtworkImageView.rightAnchor, constant: 70),
            pinchToExitArtworkImageView.widthAnchor.constraint(equalToConstant: 200),
            pinchToExitArtworkImageView.heightAnchor.constraint(equalToConstant: 100),
            
            pinchToExitLabel.centerYAnchor.constraint(equalTo: showModelLabel.centerYAnchor),
            pinchToExitLabel.centerXAnchor.constraint(equalTo: pinchToExitArtworkImageView.centerXAnchor),
            
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            continueButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -55),
        ])
        
        backgroundColor = .black
    }
    
    // MARK: - Button Action
    
    @objc
    private func didTapContinueButton(_ sender: PresentationOnboardingView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.removeFromSuperview()
        }
        
         delegate?.didTapContinueButton(self)
    }
    
}
