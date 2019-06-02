//
//  NodeAnimationListViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol NodeAnimationListDelegate: class {
    func nodeAnimationList(_ nodeAnimationList: NodeAnimationListViewController, didAddNodeAnimation animation: Animation)
}

final class NodeAnimationListViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: NodeAnimationListDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: NodeAnimationListView = {
        let mainView = NodeAnimationListView(frame: view.frame)
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
        setupNavigationItems()
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
    private func setupNavigationItems() {
        let addAnimationButton = UIImage(named: .objectCatalogButton)
        let addAnimationBarButton = UIBarButtonItem(image: addAnimationButton, style: .plain, target: self, action: #selector(didTapAddAnimationButton(_:)))
        
        let editAnimationListButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditAnimationListButton(_:)))
        
        if mainView.tableViewIsEmpty() {
            editAnimationListButton.isEnabled = false
        } else {
            editAnimationListButton.isEnabled = true
        }
        
        navigationController?.navigationBar.tintColor = .lavender
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.setLeftBarButtonItems([addAnimationBarButton], animated: true)
        navigationItem.setRightBarButtonItems([editAnimationListButton], animated: true)
    }
    
    // MARK: - Touches
    
    @objc
    private func didTapAddAnimationButton(_ sender: UIBarButtonItem) {
        guard let nodeAnimationMenu = Presenter.inject(.nodeAnimationMenu) as? NodeAnimationMenuViewController else {
            return
        }
        
        nodeAnimationMenu.delegate = self
        
        navigationController?.pushViewController(nodeAnimationMenu, animated: true)
    }
    
    @objc
    private func didTapEditAnimationListButton(_ sender: UIBarButtonItem) {
        if mainView.tableViewIsEditing() {
            sender.style = .done
            sender.title = "Done"
        } else {
            sender.style = .plain
            sender.title = "Edit"
        }
    }
    
}

// MARK: - NodeAnimationListViewDelegate

extension NodeAnimationListViewController: NodeAnimationListViewDelegate {
    func nodeAnimationListView(_ nodeAnimationListView: NodeAnimationListView, didSelectNodeAnimation animation: Animation, atIndex index: Int) {
        presentAnimationAttributes(for: animation, atIndex: index)
    }
    
    private func presentAnimationAttributes(for animationType: Animation, atIndex index: Int) {
        let animation = State.nodeAnimationTarget?.actions[index]
        
        switch animationType {
        case .move:
            guard let targetLocation = animation?.targetLocation else {
                return
            }
            
            let animationAttributes = MoveAnimationAttributes(duration: animation?.duration, targetLocation: targetLocation, animationIndex: index)
            let moveAnimationAttributes = Presenter.inject(.moveAnimationAttributes(attributes: animationAttributes))
            
            navigationController?.pushViewController(moveAnimationAttributes, animated: true)
            
        case .rotate:
            let animationAttributes = RotateAnimationAttributes(duration: animation?.duration, angle: animation?.rotationAngle, animationIndex: index)
            let rotateAnimationAttributesController = Presenter.inject(.rotateAnimationAttributes(attributes: animationAttributes))
            navigationController?.pushViewController(rotateAnimationAttributesController, animated: true)
            
        case .delay:
            let animationAttributes = DelayAnimationAttributes(duration: animation?.duration, animationIndex: index)
            let delayAnimationAttributesController = Presenter.inject(.delayAnimationAttributes(attributes: animationAttributes))
            
            navigationController?.pushViewController(delayAnimationAttributesController, animated: true)
            
        case .speechBubble:
            guard let animatedNodeLocation = State.nodeAnimationTarget?.position else {
                return
            }
            
            let animationAttributes = SpeechBubbleAnimationAttributes(duration: animation?.duration, animationIndex: index, nodeLocation: animatedNodeLocation, title: "")
            let alertAnimationAttributesController = Presenter.inject(.speechBubbleAnimationAttributes(attributes: animationAttributes))
            
            navigationController?.pushViewController(alertAnimationAttributesController, animated: true)
            
        default:
            break
        }
    }
}

// MARK: - NodeAnimationMenuDelegate

extension NodeAnimationListViewController: NodeAnimationMenuDelegate {
    func nodeAnimationMenu(_ nodeAnimationMenu: NodeAnimationMenuViewController, didSelectNodeAnimation animation: Animation) {
        delegate?.nodeAnimationList(self, didAddNodeAnimation: animation)
    }
}
