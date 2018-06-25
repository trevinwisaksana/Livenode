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
    func insert3D(model: Object)
}

final class ObjectCatalogViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: ObjectInsertionDelegate?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 300, height: 100)
    }
    
}

// MARK: - Collection View Data Source

extension ObjectCatalogViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ObjectCatalogCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ObjectCatalogViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TESTING
        
        // TODO: Insert node object to the grid
//        delegate?.insert3D(model: <#T##Object#>)
        
    }
    
}
