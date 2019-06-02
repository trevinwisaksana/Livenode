//
//  ObjectCatalogViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol ObjectCatalogDelegate: class {
    func objectCatalog(didSelectModel model: NodeModel)
}

final class ObjectCatalogViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: ObjectCatalogDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300

    lazy var mainView: ObjectCatalogView = {
        let mainView = ObjectCatalogView(frame: view.frame)
        mainView.delegate = self
        return mainView
    }()
    
    /// Pan gesture to allow scrolling on the LVNCollectionView.
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didBeginScrolling(_:)))
        return gestureRecognizer
    }()
    
    /// Tap gesture to select the 3D model to be inserted.
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectModel(_:)))
        return gestureRecognizer
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
        
        mainView.sceneView.addGestureRecognizer(panGestureRecognizer)
        mainView.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - User Interaction

extension ObjectCatalogViewController {
    @objc
    private func didBeginScrolling(_ sender: UIPanGestureRecognizer) {
        mainView.didBeginScrolling(sender, inView: view)
    }
    
    @objc
    private func didSelectModel(_ sender: UITapGestureRecognizer) {
        mainView.lvnCollectionView(didSelectModelWith: sender)
    }
}

// MARK: - Node Selection

extension ObjectCatalogViewController: ObjectCatalogViewDelegate {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectModel model: NodeModel) {
        delegate?.objectCatalog(didSelectModel: model)
    }
}
