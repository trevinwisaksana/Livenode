//
//  SceneAttributeInspectorCollectionView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SceneInspectorViewDelegate: NSObjectProtocol {
    func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, didSelectItemAtIndex index: Int)
}

public protocol SceneInspectorViewDataSource: NSObjectProtocol {
    func numberOfItems(inAdsGridView sceneInspectorView: SceneInspectorView) -> Int
}

public class SceneInspectorView: UIView {
    
    // MARK: - Internal properties
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    // Have the collection view be private so nobody messes with it.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .milk
        return collectionView
    }()
    
    private weak var delegate: SceneInspectorViewDelegate?
    private weak var dataSource: SceneInspectorViewDataSource?
    
    // MARK: - External properties
    
    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }
    
    // MARK: - Setup
    
    public init(delegate: SceneInspectorViewDelegate, dataSource: SceneInspectorViewDataSource) {
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
        collectionView.register(SceneInspectorViewCell.self)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
    
    public func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func scrollToTop(animated: Bool = true) {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension SceneInspectorView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sceneInspectorView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension SceneInspectorView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inAdsGridView: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneInspectorViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]
        
        cell.dataSource = self
        
        if let model = dataSource?.adsGridView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }
        
        return cell
    }

}

// MARK: - SceneInspectorViewCellDataSource

extension SceneInspectorView: SceneInspectorViewDataSource {
    
    public func numberOfItems(inAdsGridView sceneInspectorView: SceneInspectorView) -> Int {
        return 3
    }
    
}
