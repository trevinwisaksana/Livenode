//
//  ObjectCatalogView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol ObjectCatalogViewDelegate: class {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol ObjectCatalogViewDataSource: class {
    func viewModel(InObjectCatalogView sceneAcobjectCatalogViewtionsMenuView: ObjectCatalogView) -> ObjectCatalogViewModel
}

public class ObjectCatalogView: UIView  {
    
    // MARK: - Internal properties
    
    private static let cellWidth: CGFloat = 100.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private weak var delegate: ObjectCatalogViewDelegate?
    private weak var dataSource: ObjectCatalogViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: ObjectCatalogViewDelegate, dataSource: ObjectCatalogViewDataSource) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        collectionView.register(cell: ObjectCatalogCell.self)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource

extension ObjectCatalogView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ObjectCatalogCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ObjectCatalogView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt(indexPath: indexPath)
    }
    
    private func didSelectItemAt(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.1
        return CGSize(width: width, height: width)
    }
}

