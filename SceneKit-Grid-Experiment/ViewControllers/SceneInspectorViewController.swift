//
//  SceneInspectorViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol SceneInspectorDelegate: class {
    func colorPicker(didSelectColor color: UIColor)
}

final class SceneInspectorViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: SceneInspectorDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: SceneInspectorView = {
        let mainView = SceneInspectorView(frame: view.frame)
        mainView.delegate = self
        mainView.dataSource = self
        return mainView
    }()

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()

        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - SceneInspectorViewDelegate

extension SceneInspectorViewController: SceneInspectorViewDelegate {
    public func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, didSelectItemAtIndexPath indexPath: IndexPath) {
        transition(using: indexPath)
    }
    
    private func transition(using indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let colorPicker = Presenter.inject(.colorPickerView)
            (colorPicker as! ColorPickerViewController).delegate = self
            navigationController?.pushViewController(colorPicker, animated: true)
            
        case 1:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController?.pushViewController(colorPicker, animated: true)
            
        default:
            break
        }
    }
}

// MARK: - SceneInspectorViewDataSource

extension SceneInspectorViewController: SceneInspectorViewDataSource {
    public func viewModel(inSceneInspectorView sceneInspectorView: SceneInspectorView) -> SceneInspectorViewModel {
        let backgroundColor = State.currentDocument?.scene.backgroundColor
        let floorColor = State.currentDocument?.scene.floorColor
        
        return SceneInspector(backgroundColor: backgroundColor, floorColor: floorColor)
    }
}

// MARK: - ColorPickerDelegate

extension SceneInspectorViewController: ColorPickerDelegate {
    func didSelectColor(_ color: UIColor) {
        delegate?.colorPicker(didSelectColor: color)
    }
}
