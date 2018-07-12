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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell: ColorPickerCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.colorPickerView.delegate = self
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

// MARK: - Collection View Flow Layout

extension ObjectAttributeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.row {
        case 0:
            return CGSize(width: 300, height: 300)
        case 1:
            return CGSize(width: 300, height: 50)
        default:
            fatalError("Index path out of range.")
        }
        
    }
    
}

// MARK: - HSBColorPicker Delegate

extension ObjectAttributeViewController: HSBColorPickerDelegate {
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        viewModel.nodeSelected?.change(color: color)
    }
    
}
