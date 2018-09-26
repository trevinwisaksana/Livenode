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
    
    private static let cellHeight: CGFloat = 60.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
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

// MARK: - UICollectionView

extension SceneActionsMenuView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setupCell(at: indexPath)
    }
    
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func setupCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        let cell: SceneActionMenuCell = collectionView.dequeueReusableCell(for: indexPath)
        
        switch row {
        case 0:
            cell.buttonOutlet.setTitle(Action.move.capitalized, for: .normal)
        case 1:
            cell.buttonOutlet.setTitle(Action.delete.capitalized, for: .normal)
        case 2:
            cell.buttonOutlet.setTitle(Action.copy.capitalized, for: .normal)
        case 3:
            cell.buttonOutlet.setTitle(Action.paste.capitalized, for: .normal)
        default:
            break
        }
        
        return cell
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
