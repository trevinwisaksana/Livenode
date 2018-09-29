//
//  SceneBackgroundColorCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SceneBackgroundColorDelegate {
    func sceneBackgroundColorCell(_ sceneBackgroundColorCell: SceneBackgroundColorCell, changeBackgroundColorForModel model: SceneInspectorViewModel)
}

public class SceneBackgroundColorCell: UITableViewCell {

    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = -3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let colorViewWidth: CGFloat = Style.colorViewWidth
    private static let colorViewTopMargin: CGFloat = 15.0
    private static let colorViewBottomMargin: CGFloat = -15.0
    private static let colorViewRightMargin: CGFloat = -15.0
    
    private static let nextIndicatorImageViewTopMargin: CGFloat = 15.0
    private static let nextIndicatorImageViewBottomMargin: CGFloat = -15.0
    private static let nextIndicatorImageViewRightMargin: CGFloat = -15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Background"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = Style.containerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(colorView)
        addSubview(nextIndicatorImageView)
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: SceneBackgroundColorCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SceneBackgroundColorCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneBackgroundColorCell.titleBottomMargin),
            
            colorView.rightAnchor.constraint(equalTo: nextIndicatorImageView.leftAnchor, constant: SceneBackgroundColorCell.colorViewRightMargin),
            colorView.widthAnchor.constraint(equalToConstant: SceneBackgroundColorCell.colorViewWidth),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: SceneBackgroundColorCell.colorViewTopMargin),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneBackgroundColorCell.colorViewBottomMargin),
            
            nextIndicatorImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: SceneBackgroundColorCell.nextIndicatorImageViewRightMargin),
            nextIndicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: SceneBackgroundColorCell.nextIndicatorImageViewTopMargin),
            nextIndicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneBackgroundColorCell.nextIndicatorImageViewBottomMargin),
        ])
    }
    
    // MARK: - Dependency injection
    
    /// The model contains data used to populate the view.
    public var model: SceneInspectorViewModel? {
        didSet {
            if let model = model {
                colorView.backgroundColor = model.scene?.backgroundColor
            }
        }
    }
}
