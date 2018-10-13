//
//  NodeAnimationMenuCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class NodeAnimationMenuCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    private static let borderViewWidth: CGFloat = 0.5
    
    private lazy var animationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didSelectActionButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    weak var delegate: SceneActionMenuCellDelegate?
    
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
        addSubview(animationButton)
        addSubview(borderView)
        animationButton.fillInSuperview()
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            borderView.rightAnchor.constraint(equalTo: rightAnchor),
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.widthAnchor.constraint(equalToConstant: NodeAnimationMenuCell.borderViewWidth),
        ])
    }
    
    public func hideBorder() {
        borderView.isHidden = true
    }
    
    public func setTitle(forCellAtIndex index: Int) {
        switch index {
        case 0:
            animationButton.setTitle(Animation.move.capitalized, for: .normal)
        default:
            break
        }
    }
    
    @objc
    private func didSelectActionButton(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case Animation.move.capitalized:
            break
        default:
            break
        }
    }
    
}
