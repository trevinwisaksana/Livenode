//
//  NodeInspectorView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class NodeInspectorView: UIView {
    
    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        return tableView
    }()
    
    
}

// MARK: - UITableViewDelegate

extension NodeInspectorView: UITableViewDelegate {
    
    
    
}

// MARK: - UITableViewDataSource

extension NodeInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(atSection: indexPath.section)
    }
    
    private func setupCell(atSection section: Int) -> UITableViewCell {
        switch section {
        case 1:
            let cell: SceneBackgroundColorCell = tableView.dequeueReusableCell()
            
            return cell
        default:
            fatalError("Index out of range.")
        }
    }
}
