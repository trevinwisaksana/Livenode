//
//  FileMenuHeaderReusableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class FileMenuHeaderReusableView: UICollectionReusableView {
    
    // MARK: - Internal Properties
    
    private static let titleLabelHeight: CGFloat = 20.0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 40.0)
        label.text = "Scenes"
        return label
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: FileMenuHeaderReusableView.titleLabelHeight),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
