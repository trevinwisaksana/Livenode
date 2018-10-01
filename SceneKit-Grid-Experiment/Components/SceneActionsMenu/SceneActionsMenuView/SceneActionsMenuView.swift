//
//  SceneActionsMenuView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol SceneActionsMenuViewDelegate: class {
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectCutButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectCopyButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectPasteButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionsMenuView, didSelectDeleteButton button: UIButton)
}

public class SceneActionsMenuView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 4
    
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
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SceneActionsMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SceneActionsMenuView.numberOfItemsInSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneActionMenuCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle(forCellAtIndex: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SceneActionsMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SceneActionsMenuView.cellWidth, height: frame.height)
    }
}

// MARK: - SceneActionsMenuCellDelegate

extension SceneActionsMenuView: SceneActionsMenuCellDelegate {
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectCutButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectCutButton: button)
    }
    
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectCopyButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectCopyButton: button)
    }
    
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectPasteButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectPasteButton: button)
    }
    
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectDeleteButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectDeleteButton: button)
    }
}
