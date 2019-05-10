//
//  OnboardingViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    lazy var mainView: OnboardingView = {
        let mainView = OnboardingView(frame: view.frame)
        mainView.delegate = self
        
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
    }
    
}

// MARK: - OnboardingPresentableViewDelegate

extension OnboardingViewController: OnboardingViewDelegate {
    func didTapContinueButton(_ sender: OnboardingView) {
        let documentBrowserViewController = Presenter.inject(.documentBrowser)
        view.window?.rootViewController = documentBrowserViewController
    }
}
