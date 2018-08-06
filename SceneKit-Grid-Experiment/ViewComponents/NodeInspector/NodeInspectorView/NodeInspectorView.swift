//
//  NodeInspectorView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol NodeInspectorViewDelegate: NSObjectProtocol {
    func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol NodeInspectorViewDataSource: NSObjectProtocol {
    func viewModel(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> NodeInspectorViewModel
}

public class NodeInspectorView: UIView {
    
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
    
    private weak var delegate: NodeInspectorViewDelegate?
    private weak var dataSource: NodeInspectorViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: NodeInspectorViewDelegate, dataSource: NodeInspectorViewDataSource) {
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
        tableView.register(cell: NodeColorCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension NodeInspectorView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.nodeInspectorView(self, didSelectItemAtIndexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension NodeInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(atSection: indexPath.section)
    }
    
    private func setupCell(atSection section: Int) -> UITableViewCell {
        switch section {
        case 0:
            let cell: NodeColorCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
            }
            
            return cell
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeInspectorView.cellHeight
    }
}

// MARK: - NodeAttributesDelegate

extension NodeInspectorView: NodeAttributesDelegate {
    public func nodeColorCell(_ nodeColorCell: NodeColorCell, changeBackgroundColorForModel model: SceneInspectorViewModel) {}
}
