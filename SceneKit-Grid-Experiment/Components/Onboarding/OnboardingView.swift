//
//  OnboardingView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

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
        ])
    }
    
    // MARK: - Page Creation
    
    static func createPages() -> [OnboardingView] {
        let firstPage = OnboardingView()
        firstPage.titleLabel.text = "Create 3D presentations, present it in Augmented Reality"
        firstPage.descriptionLabel.text = "Create compelling presentations and present in Augmented Reality (AR)."
        
        let secondPage = OnboardingView()
        secondPage.titleLabel.text = "Step 1: Add a 3D model to your scene"
        secondPage.descriptionLabel.text = "Select the button shown above to choose a model you would like to include in your scene."
        
        let thirdPage = OnboardingView()
        thirdPage.titleLabel.text = "Step 2: Animate your models"
        thirdPage.descriptionLabel.text = "Select a 3D model you would like to animate and select the button show above to choose your preferred animation."
        
        let fourthPage = OnboardingView()
        fourthPage.titleLabel.text = "Step 3: Present your scene in Augmented Reality"
        fourthPage.descriptionLabel.text = "Press the button shown above to present the scene you've created!"
        
        return [firstPage, secondPage, thirdPage, fourthPage]
    }
    
}
