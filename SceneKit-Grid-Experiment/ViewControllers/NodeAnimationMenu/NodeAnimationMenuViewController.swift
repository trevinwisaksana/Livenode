//
//  NodeAnimationMenuViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol NodeAnimationMenuDelegate: class {
    func nodeAnimationMenu(_ nodeAnimationMenu: NodeAnimationMenuViewController, didSelectNodeAnimation animation: Animation)
}

final class NodeAnimationMenuViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: NodeAnimationMenuDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: NodeAnimationMenuView = {
        let mainView = NodeAnimationMenuView(delegate: self)
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
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - NodeAnimationMenuViewDelegate

extension NodeAnimationMenuViewController: NodeAnimationMenuViewDelegate {
    func nodeAnimationMenuView(_ nodeAnimationMenuView: NodeAnimationMenuView, didSelectNodeAnimation animation: Animation) {
        delegate?.nodeAnimationMenu(self, didSelectNodeAnimation: animation)
    }
}
