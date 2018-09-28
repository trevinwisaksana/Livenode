//
//  ObjectCatalogViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol ObjectInsertionDelegate: class {
    func insert3D(model: Model)
}

final class ObjectCatalogViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = 250
    private let popoverHeight: Int = 300
    
    weak var delegate: ObjectInsertionDelegate?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
}

// MARK: - Collection View Data Source

extension ObjectCatalogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ObjectCatalogCell = collectionView.dequeueReusableCell(for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.configure(with: .box)
        case 1:
            cell.configure(with: .pyramid)
        default:
            break
        }
        
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ObjectCatalogViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.insert3D(model: .box)
        case 1:
            delegate?.insert3D(model: .pyramid)
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Collection View Delegate Flow Layout

extension ObjectCatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = view.frame.width / 2.1

        return CGSize(width: width, height: width)
    }
}
