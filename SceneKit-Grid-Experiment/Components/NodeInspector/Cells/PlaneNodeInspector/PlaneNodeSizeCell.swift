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
    
    private static let targetLocationTitleTopMargin: CGFloat = 15.0
    private static let targetLocationTitleLeftMargin: CGFloat = 15.0
    
    private static let lengthTitleLabelTopMargin: CGFloat = 8.0
    private static let lengthTitleLabelLeftMargin: CGFloat = 15.0
    
    private static let widthTitleLabelTopMargin: CGFloat = 8.0
    private static let widthTitleLabelLeftMargin: CGFloat = 25.0
    private static let widthTitleLabelRightMargin: CGFloat = 15.0
    
    private static let lengthTextFieldTopMargin: CGFloat = 8.0
    private static let lengthTextFieldLeftMargin: CGFloat = 10.0
    private static let lengthTextFieldWidth: CGFloat = 100.0
    
    private static let widthTextFieldTopMargin: CGFloat = 8.0
    private static let widthTextFieldLeftMargin: CGFloat = 10.0
    private static let widthTextFieldRightMargin: CGFloat = -15.0
    private static let widthTextFieldWidth: CGFloat = 100.0
 
    private lazy var sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Size"
        return label
    }()
    
    private lazy var lengthTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "L :"
        return label
    }()
    
    private lazy var widthTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "W :"
        return label
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
        addSubview(lengthTitleLabel)
        addSubview(widthTitleLabel)
        addSubview(lengthTextField)
        addSubview(widthTextField)
        
        NSLayoutConstraint.activate([
            sizeTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PlaneNodeSizeCell.titleLeftMargin),
            sizeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: PlaneNodeSizeCell.titleTopMargin),
            sizeTitleLabel.heightAnchor.constraint(equalToConstant: PlaneNodeSizeCell.titleHeight),
            
            lengthTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: PlaneNodeSizeCell.lengthTitleLabelLeftMargin),
            lengthTitleLabel.topAnchor.constraint(equalTo: sizeTitleLabel.bottomAnchor, constant: PlaneNodeSizeCell.lengthTitleLabelTopMargin),
            
            lengthTextField.leftAnchor.constraint(equalTo: lengthTitleLabel.rightAnchor, constant: PlaneNodeSizeCell.lengthTextFieldLeftMargin),
            lengthTextField.topAnchor.constraint(equalTo: sizeTitleLabel.bottomAnchor, constant: PlaneNodeSizeCell.lengthTextFieldTopMargin),
            lengthTextField.widthAnchor.constraint(equalToConstant: PlaneNodeSizeCell.lengthTextFieldWidth),
            
            widthTitleLabel.leftAnchor.constraint(equalTo: lengthTextField.rightAnchor, constant: PlaneNodeSizeCell.widthTitleLabelLeftMargin),
            widthTitleLabel.topAnchor.constraint(equalTo: sizeTitleLabel.bottomAnchor, constant: PlaneNodeSizeCell.widthTitleLabelTopMargin),
            
            widthTextField.leftAnchor.constraint(equalTo: widthTitleLabel.rightAnchor, constant: PlaneNodeSizeCell.widthTextFieldLeftMargin),
            widthTextField.topAnchor.constraint(equalTo: sizeTitleLabel.bottomAnchor, constant: PlaneNodeSizeCell.widthTextFieldTopMargin),
            widthTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: PlaneNodeSizeCell.widthTextFieldRightMargin),
            widthTextField.widthAnchor.constraint(equalToConstant: PlaneNodeSizeCell.widthTextFieldWidth)
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

