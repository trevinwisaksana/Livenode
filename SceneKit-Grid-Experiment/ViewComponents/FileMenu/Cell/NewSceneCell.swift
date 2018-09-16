//
//  NewSceneCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class NewSceneCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    private static let titleLabelHeight: CGFloat = 20.0
    private static let titleLabelTopMargin: CGFloat = 15.0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Scene"
        label.textAlignment = .center
        return label
    }()
    
    lazy var createSceneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.masksToBounds = false
        imageView.layer.shouldRasterize = true
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 3
        
        let createSceneImage = UIImage(named: .createScene)
        imageView.image = createSceneImage
        return imageView
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(createSceneImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: NewSceneCell.titleLabelHeight),
            titleLabel.topAnchor.constraint(equalTo: createSceneImageView.bottomAnchor, constant: NewSceneCell.titleLabelTopMargin),
            
            createSceneImageView.leftAnchor.constraint(equalTo: leftAnchor),
            createSceneImageView.rightAnchor.constraint(equalTo: rightAnchor),
            createSceneImageView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
