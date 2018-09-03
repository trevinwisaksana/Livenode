//
//  UtilitiesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 02/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class UtilitiesViewController<View: UIView>: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 300
    private let popoverHeight: Int = 400
    
    lazy var mainView: View = {
        let mainView = View(frame: view.frame)
        mainView.translatesAutoresizingMaskIntoConstraints = false
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
