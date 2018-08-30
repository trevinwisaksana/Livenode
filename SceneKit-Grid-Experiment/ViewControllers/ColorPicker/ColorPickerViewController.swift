//
//  ColorPickerViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 28/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class ColorPickerViewController<View: ColorPickerPresentableView>: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 300
    private let popoverHeight: Int = 400
    
    lazy var mainView: ColorPickerPresentableView = {
        let mainView = ColorPickerPresentableView(frame: view.frame)
        mainView.translatesAutoresizingMaskIntoConstraints = false
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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
    
}
