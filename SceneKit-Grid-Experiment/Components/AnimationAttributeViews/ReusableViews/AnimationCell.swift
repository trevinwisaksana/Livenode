//
//  AnimationCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 11/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class AnimationCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = -3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let nextIndicatorImageViewTopMargin: CGFloat = 15.0
    private static let nextIndicatorImageViewBottomMargin: CGFloat = -15.0
    private static let nextIndicatorImageViewRightMargin: CGFloat = -15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Animation"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var nextIndicatorImageView: UIImageView = {
        let image = UIImage(named: .nextIndicator)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - External properties
    
    /// A delegate to modify the model
    public var delegate: SceneBackgroundColorDelegate?
    
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
        addSubview(nextIndicatorImageView)
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: AnimationCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AnimationCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: AnimationCell.titleBottomMargin),
            
            nextIndicatorImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: AnimationCell.nextIndicatorImageViewRightMargin),
            nextIndicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: AnimationCell.nextIndicatorImageViewTopMargin),
            nextIndicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: AnimationCell.nextIndicatorImageViewBottomMargin),
        ])
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: NodeInspectorViewModel? {
        didSet {
            if let model = model {
                
            }
        }
    }
    
}
