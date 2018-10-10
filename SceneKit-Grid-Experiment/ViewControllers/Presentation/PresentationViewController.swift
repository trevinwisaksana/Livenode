//
//  PresentationViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 10/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class PresentationViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    
    private func setup() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToDismiss(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        view.backgroundColor = .white
    }
    
    @objc
    private func didPinchToDismiss(_ sender: UIPinchGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Device Configuration
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
