//
//  RotateAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol RotateAniamtionAttributesViewDelegate: class {
    func rotateAniamtionAttributesView(_ rotateAniamtionAttributesView: RotateAniamtionAttributesView, didUpdateAnimationDuration duration: Int)
}

public class RotateAniamtionAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 2
    private static let cellHeight: CGFloat = 90.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private weak var delegate: RotateAniamtionAttributesViewDelegate?
    
    // MARK: - Setup
    
    public init(delegate: RotateAniamtionAttributesViewDelegate) {
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
        tableView.register(cell: AnimationDurationCell.self)
        tableView.register(cell: RotateAnimationAngleCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension RotateAniamtionAttributesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectNodeAnimation(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func didSelectNodeAnimation(atIndex index: Int) {
        switch index {
        case 0:
            break
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension RotateAniamtionAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RotateAniamtionAttributesView.numberOfItemsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: AnimationDurationCell = tableView.dequeueReusableCell()
            return cell
        case 1:
            let cell: RotateAnimationAngleCell = tableView.dequeueReusableCell()
            return cell
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RotateAniamtionAttributesView.cellHeight
    }
}
