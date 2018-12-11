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
    private static let titleBottomMargin: CGFloat = 3.0
    private static let titleLeftMargin: CGFloat = 15.0
    
    private lazy var addAnimationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .aluminium
        button.setTitle("Add animation", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    // MARK: - Pubilc Properties
    
    weak var delegate: AddAnimationCellDelegate?
    
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
        addSubview(addAnimationButton)
        addAnimationButton.fillInSuperview()
        
        addAnimationButton.addTarget(self, action: #selector(didTapAddAnimationButton(_:)), for: .touchUpInside)
    }
    
    @objc
    private func didTapAddAnimationButton(_ sender: UIButton) {
        
    }
    
}
