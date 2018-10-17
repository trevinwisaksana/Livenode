//
//  RotateAnimationAngleCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class RotateAnimationAngleCell: UITableViewCell {
    
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Angle"
        return label
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
        addSubview(titleLabel)
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: RotateAnimationAngleCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: RotateAnimationAngleCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -RotateAnimationAngleCell.titleBottomMargin),
        ])
    }

}
