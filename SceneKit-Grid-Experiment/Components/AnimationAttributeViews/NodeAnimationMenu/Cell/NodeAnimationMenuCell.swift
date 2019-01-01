//
//  NodeAnimationMenuCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class NodeAnimationMenuCell: UITableViewCell {

    // MARK: - Internal properties
    
    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
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
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: NodeAnimationMenuCell.titleLeftMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: NodeAnimationMenuCell.titleTopMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -NodeAnimationMenuCell.titleBottomMargin),
            ])
    }
    
    public func setTitle(forIndex index: Int) {
        switch index {
        case 0:
            titleLabel.text = Animation.move.capitalized
        case 1:
            titleLabel.text = Animation.rotate.capitalized
        case 2:
            titleLabel.text = Animation.speechBubble.capitalized
        case 3:
            titleLabel.text = Animation.delay.capitalized
        default:
            break
        }
    }

}
