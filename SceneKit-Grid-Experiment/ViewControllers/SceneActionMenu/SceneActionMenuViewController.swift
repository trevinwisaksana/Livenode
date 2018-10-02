//
//  SceneActionMenuViewController:.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SceneActionMenuViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 480
    private let popoverHeight: Int = 35
    
    lazy var delegate = SceneActionMenuViewControllerDelegate()
    
    lazy var mainView: SceneActionMenuView = {
        let mainView = SceneActionMenuView(delegate: delegate)
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
        
        popoverPresentationController?.backgroundColor = .black
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
