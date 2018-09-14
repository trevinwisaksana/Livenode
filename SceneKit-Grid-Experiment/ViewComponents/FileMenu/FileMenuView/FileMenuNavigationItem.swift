//
//  FileMenuNavigationItem.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

// TODO: Complete navigation item
public class FileMenuNavigationItem: UINavigationItem {
    
    // MARK: - Internal Properties
    
    lazy var createSceneBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        let buttonImage = UIImage(named: .addButton)
        button.setImage(buttonImage, for: .normal)
        
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("Select", for: .normal)
        
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    // MARK: - Setup
    
    public override init(title: String) {
        super.init(title: title)
        
        setup()
    }
    
    convenience init() {
        self.init(title: "")
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setRightBarButtonItems([createSceneBarButton, selectBarButton], animated: true)
    }
    
}
