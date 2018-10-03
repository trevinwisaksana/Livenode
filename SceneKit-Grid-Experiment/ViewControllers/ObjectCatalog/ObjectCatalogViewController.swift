//
//  ObjectCatalogViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class ObjectCatalogViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    private lazy var delegate = ObjectCatalogViewControllerDelegate()

    lazy var mainView: ObjectCatalogPresentableView = {
        let mainView = ObjectCatalogPresentableView(frame: view.frame)
        mainView.delegate = delegate
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
