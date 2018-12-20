//
//  OnboardingPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/12/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol OnboardingPresentableViewDelegate: class {
    func didTapGetStartedButton(_ sender: UIButton)
}

final class OnboardingPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .lavender
        return pageControl
    }()
    
    weak var delegate: OnboardingPresentableViewDelegate?
    
    // MARK: - Private Properties
    
    private var pages: [OnboardingView] = []
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(scrollView)
        addSubview(pageControl)
        
        scrollView.fillInSuperview()
        
        bringSubviewToFront(pageControl)
        
        pages = OnboardingView.createPages(delegate: self)
        setupSlideScrollView()
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        backgroundColor = .white
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            pageControl.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupSlideScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(pages.count), height: frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: frame.width * CGFloat(i), y: 0, width: frame.width, height: frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}

// MARK: - OnboardingViewDelegate

extension OnboardingPresentableView: OnboardingViewDelegate {
    func didTapGetStartedButton(_ sender: UIButton) {
        delegate?.didTapGetStartedButton(sender)
    }
}
