//
//  UtilitiesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 02/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class UtilitiesInspectorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var delegate = UtilitiesInspectorViewControllerDelegate()
    
    lazy var mainView: UtilitiesInspectorView = {
        let mainView = UtilitiesInspectorView(delegate: delegate)
        return mainView
    }()
    
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
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
