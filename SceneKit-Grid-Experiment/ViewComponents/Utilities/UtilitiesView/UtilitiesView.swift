//
//  UtilitiesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 03/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol UtilitiesViewDelegate: class {
    func utilitiesView(_ utilitiesView: UtilitiesView, didSelectItemAtIndexPath indexPath: IndexPath)
}

public protocol UtilitiesViewDataSource: class {
    func viewModel(InColorPickerView colorPickerView: UtilitiesView) -> UtilitiesViewModel
}

public class UtilitiesView: UIView {
    
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
    
    private weak var delegate: UtilitiesViewDelegate?
    private weak var dataSource: UtilitiesViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: UtilitiesViewDelegate, dataSource: UtilitiesViewDataSource) {
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
        tableView.register(cell: UtilitiesShareCell.self)
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

extension UtilitiesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.utilitiesView(self, didSelectItemAtIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension UtilitiesView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UtilitiesShareCell = tableView.dequeueReusableCell()
            
            return cell
            
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UtilitiesView.cellHeight
    }
}