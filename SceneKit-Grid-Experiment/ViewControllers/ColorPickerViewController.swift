//
//  ColorPickerViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 28/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func didSelectColor(_ color: UIColor)
}

final class ColorPickerViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: ColorPickerDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: ColorPickerView = {
        let mainView = ColorPickerView(frame: view.frame)
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
        
        title = "Color"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.shadowImage = UIImage()
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}

// MARK: - ColorPickerViewDelegate

extension ColorPickerViewController: ColorPickerViewDelegate {
    func didSelectColor(_ color: UIColor) {
        delegate?.didSelectColor(color)
    }
}
