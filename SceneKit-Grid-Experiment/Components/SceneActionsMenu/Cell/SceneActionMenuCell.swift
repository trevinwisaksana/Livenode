//
//  SceneActionMenuCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SceneActionsMenuDelegate: class {
    func didSelectDelete()
    func didSelectMove()
    func didSelectCopy()
    func didSelectPaste()
}

public class SceneActionMenuCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    private static let borderViewWidth: CGFloat = 0.5
    
    private lazy var actionButton: UIButton = {
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
    
    weak var delegate: SceneActionsMenuDelegate?
    
    // MARK: - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(actionButton)
        addSubview(borderView)
        actionButton.fillInSuperview()
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            borderView.rightAnchor.constraint(equalTo: rightAnchor),
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.widthAnchor.constraint(equalToConstant: SceneActionMenuCell.borderViewWidth),
        ])
    }
    
    public func setTitle(forCellAtIndex index: Int) {
        switch index {
        case 0:
            actionButton.setTitle("Cut", for: .normal)
        case 1:
            actionButton.setTitle("Copy", for: .normal)
        case 2:
            actionButton.setTitle("Paste", for: .normal)
        case 3:
            actionButton.setTitle("Delete", for: .normal)
        default:
            break
        }
    }
    
    @objc
    private func didSelectActionButton(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case Action.delete.capitalized:
            delegate?.didSelectDelete()
        case Action.copy.capitalized:
            delegate?.didSelectCopy()
        case Action.paste.capitalized:
            delegate?.didSelectPaste()
        default:
            break
        }
    }
}
