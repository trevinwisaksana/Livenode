//
//  SceneAttributeInspectorCollectionView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol SceneInspectorViewDelegate: NSObjectProtocol {
    func sceneInspectorView(_ sceneInspectorView: SceneInspectorView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol SceneInspectorViewDataSource: NSObjectProtocol {
    func viewModel(inSceneInspectorView sceneInspectorView: SceneInspectorView) -> SceneInspectorViewModel
}

public class SceneInspectorView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .aluminium
        tableView.separatorStyle = .none
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
        tableView.register(cell: SceneFloorColorCell.self)
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension SceneInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: SceneBackgroundColorCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            if let model = dataSource?.viewModel(inSceneInspectorView: self) {
                cell.model = model
            }
            
            return cell
            
        case 1:
            let cell: SceneFloorColorCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            if let model = dataSource?.viewModel(inSceneInspectorView: self) {
                cell.model = model
            }
            
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
