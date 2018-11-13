//
//  NodeInspectorViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class NodeInspectorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: NodeInspectorPresentableView = {
        let mainView = NodeInspectorPresentableView(frame: .zero)
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
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
