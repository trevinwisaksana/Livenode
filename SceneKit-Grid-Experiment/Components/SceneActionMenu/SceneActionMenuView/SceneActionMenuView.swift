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
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectCutButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectCopyButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectPasteButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectDeleteButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectMoveButton button: UIButton)
    func sceneActionMenuView(_ sceneActionMenuView: SceneActionMenuView, didSelectPinButton button: UIButton)
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
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SceneActionMenuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SceneActionMenuView.numberOfItemsInSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setupCellForItemAt(indexPath: indexPath)
    }
    
    private func setupCellForItemAt(indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneActionMenuCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle(forCellAtIndex: indexPath.row)
        cell.delegate = self
        
        if indexPath.row == indexOflastItemInSection {
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
    
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectMoveButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectMoveButton: button)
    }
    
    public func sceneActionMenuCell(_ sceneActionMenuCell: SceneActionMenuCell, didSelectPinButton button: UIButton) {
        delegate?.sceneActionMenuView(self, didSelectPinButton: button)
    }
}
