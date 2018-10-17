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
    private static let titleTopMargin: CGFloat = 20.0
    private static let titleLeftMargin: CGFloat = 15.0
    
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
        
        NSLayoutConstraint.activate([
            locationTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: MoveAnimationLocationCell.titleLeftMargin),
            locationTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: MoveAnimationLocationCell.titleTopMargin),
            locationTitleLabel.heightAnchor.constraint(equalToConstant: MoveAnimationLocationCell.titleHeight),
        ])
    }
    
}
