//
//  OnboardingTipViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 12/01/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class OnboardingTipViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 200
    private let popoverHeight: Int = 50
    
    lazy var mainView: UIView = {
        let mainView = UIView(frame: view.frame)
        mainView.backgroundColor = .yellow
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
        
        popoverPresentationController?.backgroundColor = .yellow
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMainView(_:)))
        mainView.addGestureRecognizer(tapGestureRecognizer)
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
    @objc
    private func didTapMainView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
