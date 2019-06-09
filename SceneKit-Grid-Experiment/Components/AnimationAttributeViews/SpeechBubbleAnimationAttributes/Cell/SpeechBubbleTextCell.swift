//
//  SpeechBubbleTextCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/02/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol SpeechBubbleTextCellDelegate: class {
    func speechBubble(text: String)
}

final class SpeechBubbleTextCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = -3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let speechBubbleTitleTextFieldlLeftMargin: CGFloat = 3.0
    private static let speechBubbleTitleTextFieldlRightMargin: CGFloat = -15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Text"
        return label
    }()
    
    private lazy var speechBubbleTitleTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text to be displayed"
        return textField
    }()
    
    // MARK: - External Properties
    
    weak var delegate: SpeechBubbleTextCellDelegate?
    
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
        addSubview(speechBubbleTitleTextField)
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: SpeechBubbleTextCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SpeechBubbleTextCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SpeechBubbleTextCell.titleBottomMargin),
            
            speechBubbleTitleTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            speechBubbleTitleTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: SpeechBubbleTextCell.speechBubbleTitleTextFieldlLeftMargin),
            speechBubbleTitleTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: SpeechBubbleTextCell.speechBubbleTitleTextFieldlRightMargin),
        ])
    }
    
}

// MARK: - UITextFieldDelegate

extension SpeechBubbleTextCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let speechBubbleText = text.replacingCharacters(in: range, with: string)
            delegate?.speechBubble(text: speechBubbleText)
        }
        
        return true
    }
}
