//
//  NodeAnimationMenuView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol NodeAnimationMenuViewDelegate: class {
    func nodeAnimationMenuView(_ nodeAnimationMenuView: NodeAnimationListView, didSelectNodeAnimation animation: Animation)
}

public class NodeAnimationMenuView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 3
    private static let cellHeight: CGFloat = 50.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private weak var delegate: NodeAnimationMenuViewDelegate?
    
    // MARK: - Setup
    
    public init(delegate: NodeAnimationMenuViewDelegate) {
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
        tableView.register(cell: NodeAnimationMenuCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension NodeAnimationMenuView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: If cell is selected, dismiss the entire popover, show an instruction and highlight a tile to indicate target position
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension NodeAnimationMenuView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NodeAnimationMenuView.numberOfItemsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NodeAnimationMenuCell = tableView.dequeueReusableCell()
        cell.setTitle(forIndex: indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeAnimationMenuView.cellHeight
    }
}
