//
//  PlaneNodeInspectorView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class PlaneNodeInspectorView: NodeInspectorView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
    public override init(delegate: NodeInspectorViewDelegate, dataSource: NodeInspectorViewDataSource) {
        super.init(delegate: delegate, dataSource: dataSource)
        
        self.numberOfRowsInSection = 4
        tableView.register(cell: PlaneNodeSizeCell.self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDataSource

extension PlaneNodeInspectorView {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(forRowAtIndex: indexPath.row)
    }

    private func setupCell(forRowAtIndex index: Int) -> UITableViewCell {
        switch index {
        case 0:
            let cell: NodeColorCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
            }
            
            return cell
            
        case 1:
            let cell: NodePositionCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
                cell.delegate = self
            }
            
            return cell
            
        case 2:
            let cell: NodeAngleCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
                cell.delegate = self
            }
            
            return cell
            
        case 3:
            let cell: PlaneNodeSizeCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
                cell.delegate = self
            }
            
            return cell
            
        default:
            fatalError("Index out of range.")
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaneNodeInspectorView.cellHeight
    }
}
