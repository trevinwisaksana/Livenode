//
//  SceneActionMenuViewController:.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol SceneActionMenuDelegate: class {
    func sceneActionMenu(_ sceneActionMenu: SceneActionMenuViewController, didSelectSceneActionButton button: UIButton)
}

final class SceneActionMenuViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: SceneActionMenuDelegate?
    
    // MARK: - Internal Properties
    
    lazy var mainView: SceneActionMenuView = {
        let mainView = SceneActionMenuView(delegate: self)
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    init(isNodeSelected: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        mainView.isNodeSelected = isNodeSelected
        
        if isNodeSelected {
            preferredContentSize = CGSize(width: 480, height: 35)
        } else {
            preferredContentSize = CGSize(width: 80, height: 35)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        popoverPresentationController?.backgroundColor = .black
    }
    
}

// MARK: - SceneActionMenuViewControllerDelegate

extension SceneActionMenuViewController: SceneActionsMenuViewDelegate {
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectSceneActionButton button: UIButton) {
        delegate?.sceneActionMenu(self, didSelectSceneActionButton: button)
    }
}
