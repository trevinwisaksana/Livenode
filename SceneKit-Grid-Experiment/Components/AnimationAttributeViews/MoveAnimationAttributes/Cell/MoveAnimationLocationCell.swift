//
//  MoveAnimationLocationCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class MoveAnimationLocationCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 15.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let currentLocationTitleTopMargin: CGFloat = 15.0
    private static let currentLocationTitleLeftMargin: CGFloat = 15.0
    
    private static let currentCoordinateContainerTopMargin: CGFloat = 8.0
    private static let currentCoordinateContainerLeftMargin: CGFloat = 15.0
    private static let currentCoordinateContainerRightMargin: CGFloat = -15.0
    
    private static let targetLocationTitleTopMargin: CGFloat = 15.0
    private static let targetLocationTitleLeftMargin: CGFloat = 15.0
//    private static let targetLocationTitleBottomMargin: CGFloat = -10.0
    
    private static let targetCoordinateContainerTopMargin: CGFloat = 8.0
    private static let targetCoordinateContainerLeftMargin: CGFloat = 15.0
    private static let targetCoordinateContainerRightMargin: CGFloat = -15.0
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        return label
    }()
    
    private lazy var currentLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current"
        label.textColor = .gray
        return label
    }()
    
    private lazy var targetLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Target"
        label.textColor = .gray
        return label
    }()
    
    private lazy var currentCoordinateTextFieldContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentXCoordinateTextField, currentYCoordinateTextField, currentZCoordinateTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var targetCoordinateTextFieldContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [targetXCoordinateTextField, targetYCoordinateTextField, targetZCoordinateTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var currentXCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var currentYCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var currentZCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var targetXCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var targetYCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var targetZCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - Setup
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(locationTitleLabel)
        addSubview(currentLocationTitleLabel)
        addSubview(targetLocationTitleLabel)
        addSubview(currentCoordinateTextFieldContainer)
        addSubview(targetCoordinateTextFieldContainer)
        
        NSLayoutConstraint.activate([
            locationTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.titleLeftMargin),
            locationTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: MoveAnimationLocationCell.titleTopMargin),
            locationTitleLabel.heightAnchor.constraint(equalToConstant: MoveAnimationLocationCell.titleHeight),
            
            currentLocationTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.currentLocationTitleLeftMargin),
            currentLocationTitleLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: MoveAnimationLocationCell.currentLocationTitleTopMargin),
            
            currentCoordinateTextFieldContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentCoordinateTextFieldContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.currentCoordinateContainerLeftMargin),
            currentCoordinateTextFieldContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: MoveAnimationLocationCell.currentCoordinateContainerRightMargin),
            currentCoordinateTextFieldContainer.topAnchor.constraint(equalTo: currentLocationTitleLabel.bottomAnchor, constant: MoveAnimationLocationCell.currentCoordinateContainerTopMargin),
            
            targetLocationTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.titleLeftMargin),
            targetLocationTitleLabel.topAnchor.constraint(equalTo: currentCoordinateTextFieldContainer.bottomAnchor, constant: MoveAnimationLocationCell.targetLocationTitleTopMargin),
            
            targetCoordinateTextFieldContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetCoordinateTextFieldContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.targetCoordinateContainerLeftMargin),
            targetCoordinateTextFieldContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: MoveAnimationLocationCell.targetCoordinateContainerRightMargin),
            targetCoordinateTextFieldContainer.topAnchor.constraint(equalTo: targetLocationTitleLabel.bottomAnchor, constant: MoveAnimationLocationCell.targetCoordinateContainerTopMargin),
        ])
    }
    
}
