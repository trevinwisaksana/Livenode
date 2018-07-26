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
    
    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        return tableView
    }()
    
    private weak var delegate: SceneInspectorViewDelegate?
    private weak var dataSource: SceneInspectorViewDataSource?
    
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
        tableView.register(SceneInspectorViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate

extension SceneInspectorView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sceneInspectorView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension SceneInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inAdsGridView: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SceneInspectorViewCell = tableView.dequeueReusableCell()
        
        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]
        
        cell.dataSource = self
        
        return cell
    }
}

// MARK: - SceneInspectorViewCellDataSource

extension SceneInspectorView: SceneInspectorViewDataSource {
    
    public func numberOfItems(inAdsGridView sceneInspectorView: SceneInspectorView) -> Int {
        return 3
    }
    
}
