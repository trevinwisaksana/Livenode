//
//  SceneAttributeInspectorCollectionView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SceneInspectorViewDelegate: NSObjectProtocol {
    func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol SceneInspectorViewDataSource: NSObjectProtocol {
    func numberOfItems(inSceneInspectorView sceneInspectorView: SceneInspectorView) -> Int
}

public class SceneInspectorView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
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
        tableView.register(cell: SceneBackgroundColorCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension SceneInspectorView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sceneInspectorView(self, didSelectItemAtIndexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension SceneInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inSceneInspectorView: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(atSection: indexPath.section)
    }
    
    private func setupCell(atSection section: Int) -> UITableViewCell {
        switch section {
        case 0:
            let cell: SceneBackgroundColorCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            return cell
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SceneInspectorView.cellHeight
    }
}

// MARK: - SceneInspectorViewCellDataSource

extension SceneInspectorView: SceneBackgroundColorDelegate {
    public func sceneBackgroundColorCell(_ sceneBackgroundColorCell: SceneBackgroundColorCell, changeBackgroundColorForModel model: SceneInspectorViewModel) {
        
    }
}
