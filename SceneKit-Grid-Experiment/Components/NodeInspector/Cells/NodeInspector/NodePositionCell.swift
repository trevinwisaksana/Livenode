//
//  NodePositionCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 02/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol NodePositionCellDelegate: class {
    func nodePositionCell(_ nodePositionCell: NodePositionCell, didUpdateNodePosition position: SCNVector3)
}

public class NodePositionCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 5.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let targetCoordinateTextFieldWidth: CGFloat = 60.0
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Target Location"
        return label
    }()
    
    private lazy var xCoordinateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "X:"
        return label
    }()
    
    private lazy var yCoordinateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Y:"
        return label
    }()
    
    private lazy var zCoordinateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Z:"
        return label
    }()
    
    private lazy var targetXCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didFinishEditingCoordinateTextField(_:)), for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var targetYCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didFinishEditingCoordinateTextField(_:)), for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var targetZCoordinateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didFinishEditingCoordinateTextField(_:)), for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - External Properties
    
    weak var delegate: NodePositionCellDelegate?
    
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
        addSubview(xCoordinateTitleLabel)
        addSubview(yCoordinateTitleLabel)
        addSubview(zCoordinateTitleLabel)
        addSubview(targetXCoordinateTextField)
        addSubview(targetYCoordinateTextField)
        addSubview(targetZCoordinateTextField)
        
        targetXCoordinateTextField.delegate = self
        targetYCoordinateTextField.delegate = self
        targetZCoordinateTextField.delegate = self
        
        NSLayoutConstraint.activate([
            locationTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: NodePositionCell.titleLeftMargin),
            locationTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: NodePositionCell.titleTopMargin),
            locationTitleLabel.heightAnchor.constraint(equalToConstant: NodePositionCell.titleHeight),
            
            xCoordinateTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            xCoordinateTitleLabel.centerYAnchor.constraint(equalTo: targetXCoordinateTextField.centerYAnchor),
            
            targetXCoordinateTextField.leftAnchor.constraint(equalTo: xCoordinateTitleLabel.rightAnchor, constant: 10),
            targetXCoordinateTextField.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 8),
            targetXCoordinateTextField.widthAnchor.constraint(equalToConstant: NodePositionCell.targetCoordinateTextFieldWidth),
            
            yCoordinateTitleLabel.leftAnchor.constraint(equalTo: targetXCoordinateTextField.rightAnchor, constant: 15),
            yCoordinateTitleLabel.centerYAnchor.constraint(equalTo: targetYCoordinateTextField.centerYAnchor),
            
            targetYCoordinateTextField.leftAnchor.constraint(equalTo: yCoordinateTitleLabel.rightAnchor, constant: 10),
            targetYCoordinateTextField.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 8),
            targetYCoordinateTextField.widthAnchor.constraint(equalToConstant: NodePositionCell.targetCoordinateTextFieldWidth),
            
            zCoordinateTitleLabel.leftAnchor.constraint(equalTo: targetYCoordinateTextField.rightAnchor, constant: 15),
            zCoordinateTitleLabel.centerYAnchor.constraint(equalTo: targetZCoordinateTextField.centerYAnchor),
            
            targetZCoordinateTextField.leftAnchor.constraint(equalTo: zCoordinateTitleLabel.rightAnchor, constant: 10),
            targetZCoordinateTextField.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 8),
            targetZCoordinateTextField.widthAnchor.constraint(equalToConstant: NodePositionCell.targetCoordinateTextFieldWidth),
        ])
    }
    
    // MARK: - Text Field Interactions
    
    @objc
    private func didFinishEditingCoordinateTextField(_ sender: UITextField) {
        guard let xCoordinate = Double(targetXCoordinateTextField.text ?? "0.0"),
              let yCoordinate = Double(targetYCoordinateTextField.text ?? "0.0"),
              let zCoordinate = Double(targetZCoordinateTextField.text ?? "0.0")
        else {
            return
        }
        
        let updatedLocation = SCNVector3(xCoordinate, yCoordinate, zCoordinate)
        delegate?.nodePositionCell(self, didUpdateNodePosition: updatedLocation)
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: NodeInspectorViewModel? {
        didSet {
            if let position = model?.position {
                targetXCoordinateTextField.text = "\(position.x)"
                targetYCoordinateTextField.text = "\(position.y)"
                targetZCoordinateTextField.text = "\(position.z)"
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension NodePositionCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
