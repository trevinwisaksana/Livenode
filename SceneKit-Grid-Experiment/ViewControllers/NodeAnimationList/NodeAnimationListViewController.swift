//
//  NodeAnimationListViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class NodeAnimationListViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var delegate = NodeAnimationListViewControllerDelegate()
    
    lazy var mainView: NodeAnimationListView = {
        let mainView = NodeAnimationListView(delegate: delegate)
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
        }
        
        editAnimationListButton.isEnabled = true
        
        navigationController?.navigationBar.tintColor = .lavender
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.setLeftBarButtonItems([addAnimationBarButton], animated: true)
        navigationItem.setRightBarButtonItems([editAnimationListButton], animated: true)
    }
    
    // MARK: - Touches
    
    @objc
    private func didTapAddAnimationButton(_ sender: UIBarButtonItem) {
        let nodeAnimationMenu = Presenter.inject(.nodeAnimationMenu)
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
