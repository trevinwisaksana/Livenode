//
//  PlaneNodeSizeCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol PlaneNodeSizeCellDelegate: class {
    func planeNodeSizeCell(_ planeNodeSizeCell: PlaneNodeSizeCell, didUpdatePlaneSize size: CGSize)
}

public class PlaneNodeSizeCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 5.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let currentLocationTitleTopMargin: CGFloat = 15.0
    private static let currentLocationTitleLeftMargin: CGFloat = 15.0
    
    private static let currentCoordinateContainerTopMargin: CGFloat = 8.0
    private static let currentCoordinateContainerLeftMargin: CGFloat = 15.0
    private static let currentCoordinateContainerRightMargin: CGFloat = -15.0
    
    private static let targetLocationTitleTopMargin: CGFloat = 15.0
    private static let targetLocationTitleLeftMargin: CGFloat = 15.0
    
    private static let targetCoordinateContainerTopMargin: CGFloat = 8.0
    private static let targetCoordinateContainerLeftMargin: CGFloat = 15.0
    private static let targetCoordinateContainerRightMargin: CGFloat = -15.0
    
    private lazy var sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Size"
        return label
    }()
    
    private lazy var widthTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "W:"
        return label
    }()
    
    private lazy var lengthTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "L:"
        return label
    }()
    
    private lazy var sizeTextFieldContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [widthTitleLabel, widthTextField, lengthTitleLabel, lengthTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var widthTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didFinishEditingCoordinateTextField(_:)), for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var lengthTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didFinishEditingCoordinateTextField(_:)), for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - External Properties
    
    weak var delegate: PlaneNodeSizeCellDelegate?
    
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
        addSubview(sizeTitleLabel)
        addSubview(sizeTextFieldContainer)
        
        NSLayoutConstraint.activate([
            sizeTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PlaneNodeSizeCell.titleLeftMargin),
            sizeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: PlaneNodeSizeCell.titleTopMargin),
            sizeTitleLabel.heightAnchor.constraint(equalToConstant: PlaneNodeSizeCell.titleHeight),
            
            sizeTextFieldContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            sizeTextFieldContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: PlaneNodeSizeCell.targetCoordinateContainerLeftMargin),
            sizeTextFieldContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: PlaneNodeSizeCell.targetCoordinateContainerRightMargin),
            sizeTextFieldContainer.topAnchor.constraint(equalTo: sizeTitleLabel.bottomAnchor, constant: PlaneNodeSizeCell.targetCoordinateContainerTopMargin),
            ])
    }
    
    // MARK: - Text Field Interactions
    
    @objc
    private func didFinishEditingCoordinateTextField(_ sender: UITextField) {
        
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: NodeInspectorViewModel? {
        didSet {
            
        }
    }
    
}

