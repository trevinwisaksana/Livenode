//
//  RootNavigationController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class RootNavigationController: UINavigationController {
    
    // MARK: - Setup
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        navigationBar.barTintColor = .milk
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
