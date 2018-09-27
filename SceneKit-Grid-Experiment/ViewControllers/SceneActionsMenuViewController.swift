//
//  PopoverMenuViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SceneActionsMenuViewController<View: UIView>: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 400
    private let popoverHeight: Int = 35
    
    lazy var mainView: View = {
        let mainView = View(frame: view.frame)
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

extension SceneActionsMenuViewController: SceneActionsMenuDelegate {
    func move() {
//        viewModel.makeNodeMovable()
//        menuAction?.move()
        
        dismiss(animated: true, completion: nil)
    }
    
    func delete() {
//        viewModel.removeNode()
        
        dismiss(animated: true, completion: nil)
    }
    
    func paste() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func copy() {
        
        dismiss(animated: true, completion: nil)
    }
}
