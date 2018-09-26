//
//  SceneActionsMenuView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 24/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SceneActionsMenuViewDelegate: class {
    func sceneActionsMenuView(_ sceneActionsMenuView: SceneActionsMenuView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol SceneActionsMenuViewDataSource: class {
    func viewModel(InSceneActionsMenuView sceneActionsMenuView: SceneActionsMenuView) -> SceneActionsMenuViewModel
}

public class SceneActionsMenuView: UIView {
    
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
    
    private weak var delegate: SceneActionsMenuViewDelegate?
    private weak var dataSource: SceneActionsMenuViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: SceneActionsMenuViewDelegate, dataSource: SceneActionsMenuViewDataSource) {
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
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SceneActionMenuCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

// MARK: - UICollectionView

extension SceneActionsMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SceneActionsMenuView.cellWidth, height: frame.height)
    }
}

// MARK: - SceneActionsMenuDelegate

extension SceneActionsMenuView: SceneActionsMenuDelegate {
    func move() {
        
    }
    
    func delete() {
       
    }
    
    func paste() {
        
    }
    
    func copy() {
        
    }
}
