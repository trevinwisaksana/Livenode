//
//  MoveAnimationAttributesViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class MoveAnimationAttributesViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: MoveAnimationAttributesView = {
        let mainView = MoveAnimationAttributesView(frame: .zero)
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    init(animationAttributes: MoveAnimationAttributes) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.dataSource = animationAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = "Move"
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
