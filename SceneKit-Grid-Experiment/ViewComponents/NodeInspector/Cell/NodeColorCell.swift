//
//  NodeColorCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol NodeAttributesDelegate {
    func nodeColorCell(_ nodeColorCell: NodeColorCell, changeBackgroundColorForModel model: SceneInspectorViewModel)
}

public class NodeColorCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private static let colorViewWidth: CGFloat = 60.0
    private static let colorViewTopMargin: CGFloat = 15.0
    private static let colorViewBottomMargin: CGFloat = 15.0
    private static let colorViewRightMargin: CGFloat = 15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Color"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - External properties
    
    /// A delegate to modify the model
    public var delegate: NodeAttributesDelegate?
    
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
        
        backgroundColor = .milk
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: NodeColorCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: NodeColorCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NodeColorCell.titleBottomMargin),
            
            colorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -NodeColorCell.colorViewRightMargin),
            colorView.widthAnchor.constraint(equalToConstant: NodeColorCell.colorViewWidth),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: NodeColorCell.colorViewTopMargin),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NodeColorCell.colorViewBottomMargin),
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
