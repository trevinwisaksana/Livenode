//
//  FileCatalogView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol FileMenuViewDelegate: NSObjectProtocol {
    func fileMenuView(_ fileMenuView: FileMenuView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol FileMenuViewDataSource: NSObjectProtocol {
    func viewModel(inFileMenuView fileMenuView: FileMenuView) -> FileMenuViewModel
}

public class FileMenuView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .aluminium
        return collectionView
    }()
    
    private weak var delegate: FileMenuViewDelegate?
    private weak var dataSource: FileMenuViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: FileMenuViewDelegate, dataSource: FileMenuViewDataSource) {
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
        collectionView.register(SceneDocumentCell.self)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
    
}

// MARK: - UICollectionViewDataSource

extension FileMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneDocumentCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: RecentsCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        return reusableView
    }
}

// MARK: - UICollectionViewDelegate

extension FileMenuView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
