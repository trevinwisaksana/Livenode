//
//  SceneFloorColorCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 07/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

// TODO: Reuse the SceneBackgroundColorCell because it is very similar to SceneFloorColorCell
public class SceneFloorColorCell: UITableViewCell {
    
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
        label.text = "Floor"
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
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: SceneFloorColorCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SceneFloorColorCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneFloorColorCell.titleBottomMargin),
            
            colorView.rightAnchor.constraint(equalTo: nextIndicatorImageView.leftAnchor, constant: SceneFloorColorCell.colorViewRightMargin),
            colorView.widthAnchor.constraint(equalToConstant: SceneFloorColorCell.colorViewWidth),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: SceneFloorColorCell.colorViewTopMargin),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneFloorColorCell.colorViewBottomMargin),
            
            nextIndicatorImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: SceneFloorColorCell.nextIndicatorImageViewRightMargin),
            nextIndicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: SceneFloorColorCell.nextIndicatorImageViewTopMargin),
            nextIndicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: SceneFloorColorCell.nextIndicatorImageViewBottomMargin),
            ])
    }
    
    // MARK: - Dependency injection
    
    // TODO: Change the view model to a ColorAttributeViewModel
    // NOTE: SceneInspectorViewModel is an overkill because it only needs one color
    public var model: SceneInspectorViewModel? {
        didSet {
            if let model = model {
                colorView.backgroundColor = model.scene?.floorColor
            }
        }
    }
    
}
