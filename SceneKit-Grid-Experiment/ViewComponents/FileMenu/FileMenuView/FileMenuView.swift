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
    
    private static let cellHeight: CGFloat = 225.0
    private static let cellWidth: CGFloat = 200.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
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
        collectionView.register(cell: SceneDocumentCell.self)
        collectionView.register(cell: NewSceneCell.self)
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
        return setupCell(for: indexPath)
    }
    
    private func setupCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        switch row {
        case 0:
            let cell: NewSceneCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            let cell: SceneDocumentCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: RecentsCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        return reusableView
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewLayoutDelegate

extension FileMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FileMenuView.cellWidth, height: FileMenuView.cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // TODO: Use FileMenuViewLayoutConfiguration
        return UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
    }
}

// MARK: - UICollectionViewDelegate

extension FileMenuView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            transition(using: indexPath)
    }
    
    private func transition(using indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        default:
            break
        }
    }
}
