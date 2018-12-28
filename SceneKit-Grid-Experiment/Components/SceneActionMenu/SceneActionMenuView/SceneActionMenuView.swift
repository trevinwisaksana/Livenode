//
//  SceneActionMenuView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol SceneActionsMenuViewDelegate: class {
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectSceneActionButton button: UIButton)
}

public class SceneActionMenuView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 6
    private let indexOflastItemInSection: Int = SceneActionMenuView.numberOfItemsInSection - 1
    
    private static let cellWidth: CGFloat = 80.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private weak var delegate: SceneActionsMenuViewDelegate?
    
    // MARK: - Setup
    
    public init(delegate: SceneActionsMenuViewDelegate) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        
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
        collectionView.register(cell: SceneActionMenuCell.self)
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
    
    // MARK: - Public
    
    var isNodeSelected = false
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SceneActionMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isNodeSelected {
            return SceneActionMenuView.numberOfItemsInSection
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setupCellForItemAt(indexPath: indexPath)
    }
    
    private func setupCellForItemAt(indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneActionMenuCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle(forCellAtIndex: indexPath.row)
        cell.delegate = self
        
        if indexPath.row == indexOflastItemInSection || !isNodeSelected {
            cell.hideBorder()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SceneActionMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SceneActionMenuView.cellWidth, height: frame.height)
    }
}

// MARK: - SceneActionMenuCellDelegate

extension SceneActionMenuView: SceneActionMenuCellDelegate {
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectSceneActionButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectSceneActionButton: button)
    }
}
