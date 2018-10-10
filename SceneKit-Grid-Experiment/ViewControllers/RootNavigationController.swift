//
//  RootNavigationController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class RootNavigationController: UINavigationController {
    
    // MARK: - Setup
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setup()
    }
    
    private func setup() {
        navigationBar.barTintColor = .aluminium
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .lavender
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
