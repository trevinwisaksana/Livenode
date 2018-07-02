//
//  ObjectAttributeViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class ObjectAttributeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = ObjectAttributeViewModel()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

// MARK: - Collection View Data Source

extension ObjectAttributeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ObjectAttributeCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ObjectAttributeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - Object Attribute Delegate

extension ObjectAttributeViewController: ObjectAttributeDelegate {
    
    func changeColor() {
        viewModel.nodeSelected?.change(color: .green)
    }
    
}
