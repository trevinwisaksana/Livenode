//
//  AttributesInspectorViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class AttributesInspectorViewController<View: UIView>: UIViewController {
    
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
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
    }
    
}
