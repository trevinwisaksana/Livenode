//
//  ObjectCatalogViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class ObjectCatalogViewController<View: UIView>: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 350
    private let popoverHeight: Int = 300
    
    lazy var mainView: View = {
        let mainView = View(frame: view.frame)
        return mainView
    }()
    
//    weak var delegate: ObjectInsertionDelegate?
    
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
