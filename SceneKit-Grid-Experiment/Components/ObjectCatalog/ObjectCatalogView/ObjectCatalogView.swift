//
//  ObjectCatalogView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol ObjectCatalogViewDelegate: class {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectNodeModel model: NodeModel)
}

public protocol ObjectCatalogViewDataSource: class {
    func objectCatalogView(_ objectCatalogView: ObjectCatalogView, modelAtIndex index: Int) -> ObjectCatalogViewModel
    func numberOfItems(InObjectCatalogView inObjectCatalogView: ObjectCatalogView) -> Int
}

public class ObjectCatalogView: UIView  {
    
    // MARK: - Internal properties
    
    private static let cellWidth: CGFloat = 130.0
    private static let segmentedIndexTopMargin: CGFloat = 10.0
    
    private static let collectionViewLeftMargin: CGFloat = 20.0
    private static let collectionViewRightMargin: CGFloat = -20.0
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Basic", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Ornaments", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
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
        addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: ObjectCatalogView.segmentedIndexTopMargin),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: ObjectCatalogView.collectionViewLeftMargin),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: ObjectCatalogView.collectionViewRightMargin),
        ])
    }
    
    // MARK: - Public
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource

extension ObjectCatalogView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(InObjectCatalogView: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ObjectCatalogCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let model = dataSource?.objectCatalogView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ObjectCatalogView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt(indexPath)
    }
    
    private func didSelectItemAt(_ indexPath: IndexPath) {
        let viewModel = dataSource?.objectCatalogView(self, modelAtIndex: indexPath.row)
        
        guard let nodeModel = viewModel?.nodeModel else {
            return
        }
        
        delegate?.objectCatalogView(self, didSelectNodeModel: nodeModel)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ObjectCatalogView.cellWidth, height: ObjectCatalogView.cellWidth)
    }
}
