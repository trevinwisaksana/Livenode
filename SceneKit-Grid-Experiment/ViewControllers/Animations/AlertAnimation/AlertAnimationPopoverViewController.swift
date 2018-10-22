//
//  AlertAnimationPopoverViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class AlertAnimationPopoverViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 50
    private let popoverHeight: Int = 100
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.clear.cgColor
    }
    
}
