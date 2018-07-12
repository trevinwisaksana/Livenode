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
        
        preferredContentSize = CGSize(width: 300, height: 400)
    }
    
}

// MARK: - Collection View Data Source

extension ObjectAttributeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell: ColorPickerCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case 1:
            let cell: ObjectAttributeCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        default:
            fatalError("Index path out of range.")
        }
        
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
