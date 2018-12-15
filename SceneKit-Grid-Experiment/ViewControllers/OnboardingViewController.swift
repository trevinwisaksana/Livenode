//
//  OnboardingViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    lazy var mainView: OnboardingPresentableView = {
        let mainView = OnboardingPresentableView(frame: view.frame)
        mainView.delegate = self
        mainView.scrollView.delegate = self
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

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.scrollViewDidScroll(scrollView)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // TODO: Fix autolayout issue when device is rotated
//        mainView.setupSlideScrollView()
    }
}

// MARK: - OnboardingPresentableViewDelegate

extension OnboardingViewController: OnboardingPresentableViewDelegate {
    func didTapGetStartedButton(_ sender: UIButton) {
        let documentBrowserViewController = Presenter.inject(.documentBrowser)
        view.window?.rootViewController = documentBrowserViewController
    }
}
