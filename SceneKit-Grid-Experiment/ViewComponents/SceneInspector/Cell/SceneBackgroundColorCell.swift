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
    private static let titleBottomMargin: CGFloat = 3.0
    private static let titleLeftMargin: CGFloat = 5.0
    
    private static let colorViewHeight: CGFloat = 20.0
    private static let colorViewTopMargin: CGFloat = 3.0
    private static let colorViewBottomMargin: CGFloat = 3.0
    private static let colorViewRightMargin: CGFloat = 5.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - External properties
    
    /// A delegate to modify the model
    public var delegate: SceneBackgroundColorDelegate?
    
    // MARK: - Setup
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        
        backgroundColor = .white
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: SceneBackgroundColorCell.titleLeftMargin),
            titleLabel.heightAnchor.constraint(equalToConstant: SceneBackgroundColorCell.titleHeight),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SceneBackgroundColorCell.titleBottomMargin),
            
            colorView.rightAnchor.constraint(equalTo: rightAnchor, constant: SceneBackgroundColorCell.colorViewRightMargin),
            colorView.heightAnchor.constraint(equalToConstant: SceneBackgroundColorCell.colorViewHeight),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SceneBackgroundColorCell.colorViewBottomMargin),
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
