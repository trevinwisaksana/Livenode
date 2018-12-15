//
//  OnboardingView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol OnboardingViewDelegate: class {
    func didTapGetStartedButton(_ sender: UIButton)
}

final class OnboardingView: UIView {
  
    // MARK: - Internal Properties
    
    lazy var instructionImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .lavender
        label.font = UIFont(name: "Avenir-Black", size: 18)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 16)
        return label
    }()
    
    lazy var getStartedButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.setTitle("Get started", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.backgroundColor = .lavender
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapGetStartedButton(_:)), for: .touchUpInside)
        return button
    }()
    
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
        addSubview(instructionImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(getStartedButton)
        
        NSLayoutConstraint.activate([
                instructionImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
                instructionImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                instructionImageView.widthAnchor.constraint(equalToConstant: 300),
                instructionImageView.heightAnchor.constraint(equalToConstant: 300),
            
                titleLabel.topAnchor.constraint(equalTo: instructionImageView.bottomAnchor, constant: 50),
                titleLabel.centerXAnchor.constraint(equalTo: instructionImageView.centerXAnchor),
                titleLabel.widthAnchor.constraint(equalToConstant: 500),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                descriptionLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
                descriptionLabel.widthAnchor.constraint(equalToConstant: 400),
                
                getStartedButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                getStartedButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
                getStartedButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    // MARK: - Button Action
    
    @objc
    private func didTapGetStartedButton(_ sender: UIButton) {
        delegate?.didTapGetStartedButton(sender)
    }
    
    // MARK: - Page Creation
    
    static func createPages(delegate: OnboardingViewDelegate) -> [OnboardingView] {
        let firstPage = OnboardingView()
        firstPage.titleLabel.text = "Create presentations & present it in Augmented Reality"
        firstPage.descriptionLabel.text = "Livenode gives you the ability to create compelling presentations and immersively storytell it in Augmented Reality. Here's a quick tip on how to use it."
        
        let secondPage = OnboardingView()
        secondPage.titleLabel.text = "First, add a 3D model to your scene"
        secondPage.descriptionLabel.text = "Select the button shown above and choose a 3D model you would like to include into your scene."
        
        let thirdPage = OnboardingView()
        thirdPage.titleLabel.text = "Second, animate your 3D models"
        thirdPage.descriptionLabel.text = "Select a 3D model you would like to animate. Then select the button show above to choose your preferred animation."
        
        let fourthPage = OnboardingView()
        fourthPage.delegate = delegate
        fourthPage.getStartedButton.isHidden = false
        fourthPage.titleLabel.text = "Last but not least, present your scene!"
        fourthPage.descriptionLabel.text = "Press the play button shown above to present the scene you've created in Augmented Reality."
        
        return [firstPage, secondPage, thirdPage, fourthPage]
    }
    
}
