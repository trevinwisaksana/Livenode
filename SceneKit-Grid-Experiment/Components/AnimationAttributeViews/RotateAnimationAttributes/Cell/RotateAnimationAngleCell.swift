//
//  RotateAnimationAngleCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol RotateAnimationAngleCellDelegate: class {
    func rotateAnimationAngleCell(_ rotateAnimationAngleCell: RotateAnimationAngleCell, didUpdateRotationAngle angle: CGFloat)
}

public class RotateAnimationAngleCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = -3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let angleTextFieldlLeftMargin: CGFloat = 20.0
    private static let angleTextFieldlRightMargin: CGFloat = -15.0
    private static let angleTextFieldlWidth: CGFloat = 50.0
    
    private static let plusMinusSegmentedControlWidth: CGFloat = 100.0
    private static let plusMinusSegmentedControlRightMargin: CGFloat = -15.0
    
    private var currentAngleValue: Int = 0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Angle"
        return label
    }()
    
    private lazy var angleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.text = "0˚"
        return textField
    }()
    
    private lazy var plusMinusSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "+", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "-", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(didSelectSegmentedIndex(_:)), for: .valueChanged)
        
        let font = UIFont.systemFont(ofSize: 15)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.isMomentary = true
        return segmentedControl
    }()
    
    // MARK: - External Properties
    
    weak var delegate: RotateAnimationAngleCellDelegate?
    
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
        addSubview(titleLabel)
        addSubview(angleTextField)
        addSubview(plusMinusSegmentedControl)
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: RotateAnimationAngleCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: RotateAnimationAngleCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: RotateAnimationAngleCell.titleBottomMargin),
            
            angleTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            angleTextField.widthAnchor.constraint(equalToConstant: RotateAnimationAngleCell.angleTextFieldlWidth),
            angleTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: RotateAnimationAngleCell.angleTextFieldlLeftMargin),
            angleTextField.rightAnchor.constraint(equalTo: plusMinusSegmentedControl.leftAnchor, constant: RotateAnimationAngleCell.angleTextFieldlRightMargin),
            
            plusMinusSegmentedControl.centerYAnchor.constraint(equalTo: angleTextField.centerYAnchor),
            plusMinusSegmentedControl.widthAnchor.constraint(equalToConstant: RotateAnimationAngleCell.plusMinusSegmentedControlWidth),
            plusMinusSegmentedControl.rightAnchor.constraint(equalTo: rightAnchor, constant: RotateAnimationAngleCell.plusMinusSegmentedControlRightMargin)
        ])
    }
    
    @objc
    private func didSelectSegmentedIndex(_ sender: UISegmentedControl) {
        // TODO: Keep track if the number becomes negative
        if sender.selectedSegmentIndex == 0 {
            currentAngleValue += 5
        } else {
            currentAngleValue -= 5
        }
        
        angleTextField.text = "\(currentAngleValue)˚"
        delegate?.rotateAnimationAngleCell(self, didUpdateRotationAngle: CGFloat(currentAngleValue))
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: RotateAnimationAttributesViewModel? {
        didSet {
            if let model = model {
                angleTextField.text = "\(Int(model.angle ?? 0.0))˚"
                currentAngleValue = Int(model.angle ?? 0.0)
            }
        }
    }

}
