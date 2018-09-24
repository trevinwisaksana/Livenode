//
//  DocumentBrowserViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class DocumentBrowserViewController: UIDocumentBrowserViewController {
    
    // MARK: - Internal Properties
    
    lazy var browserDelegate: DocumentBrowserDelegate = DocumentBrowserDelegate()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.tintColor = .lavender
        browserUserInterfaceStyle = .white
        
        allowsDocumentCreation = true
        delegate = browserDelegate
    }
}
