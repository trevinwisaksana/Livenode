//
//  OnboardingView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol OnboardingViewDelegate: class {
    func didTapContinueButton(_ sender: OnboardingView)
}

final class OnboardingView: UIView {
  
    // MARK: - Internal Properties
    
    lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .onboardingImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create presentations, present using Augmented Reality"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Show your ideas in 3D and present it in a fun and immersive way"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "SFProDisplay-Regular", size: 24)
        return label
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.lavender, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 25)
        button.addTarget(self, action: #selector(didTapContinueButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabelSideMargin: CGFloat = 90.0
    private let titleLabelTopMargin: CGFloat = 90.0
    
    weak var delegate: OnboardingViewDelegate?
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(artworkImageView)
        addSubview(continueButton)
        
        NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: titleLabelTopMargin),
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 100),
                titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -titleLabelSideMargin),
                
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
                subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -titleLabelSideMargin),
            
                artworkImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
                artworkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                artworkImageView.widthAnchor.constraint(equalToConstant: 500),
                artworkImageView.heightAnchor.constraint(equalToConstant: 500),
                
                continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
                continueButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -100),
        ])
        
        backgroundColor = .white
    }
    
    // MARK: - Button Action
    
    @objc
    private func didTapContinueButton(_ sender: UIButton) {
        delegate?.didTapContinueButton(self)
    }
    
}
