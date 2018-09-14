//
//  FileMenuNavigationItem.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class FileMenuNavigationItem: UINavigationItem {
    
    // MARK: - Internal Properties
    
    lazy var createSceneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        return barButton
    }()
    
    
    
    // MARK: - Initializer
    
    public override init(title: String) {
        super.init(title: title)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
