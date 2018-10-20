//
//  MoveAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 14/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol MoveAnimationAttributesViewDelegate: class {
    func moveAnimationAttributesView(_ moveAnimationAttributesView: MoveAnimationAttributesView, didUpdateAnimationDuration duration: TimeInterval, forAnimationAtIndex index: Int)
    func moveAnimationAttributesView(_ moveAnimationAttributesView: MoveAnimationAttributesView, didUpdateAnimationLocation location: SCNVector3, forAnimationAtIndex index: Int)
}

public class MoveAnimationAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 2
    private static let animationDurationCellHeight: CGFloat = 90.0
    private static let moveAnimationLocationCellHeight: CGFloat = 90.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Public Properties
    
    public weak var delegate: MoveAnimationAttributesViewDelegate?
    public var dataSource: MoveAnimationAttributes?
    
    // MARK: - Setup
    
    public init(delegate: MoveAnimationAttributesViewDelegate) {
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
        tableView.register(cell: MoveAnimationLocationCell.self)
        
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension MoveAnimationAttributesView: UITableViewDelegate {
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

extension MoveAnimationAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoveAnimationAttributesView.numberOfItemsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: AnimationDurationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            cell.model = dataSource
            return cell
        case 1:
            let cell: MoveAnimationLocationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            cell.model = dataSource
            return cell
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return MoveAnimationAttributesView.animationDurationCellHeight
        case 1:
            return MoveAnimationAttributesView.moveAnimationLocationCellHeight
        default:
            return 60.0
        }
    }
}

// MARK: - AnimationDurationCellDelegate

extension MoveAnimationAttributesView: AnimationDurationCellDelegate {
    public func animationDurationCell(_ animationDurationCell: AnimationDurationCell, didUpdateAnimationDuration duration: TimeInterval) {
        guard let animationIndex = dataSource?.animationIndex else { return }
        delegate?.moveAnimationAttributesView(self, didUpdateAnimationDuration: duration, forAnimationAtIndex: animationIndex)
    }
}

// MARK: - MoveAnimationLocationCellDelegate

extension MoveAnimationAttributesView: MoveAnimationLocationCellDelegate {
    public func moveAnimationLocationCell(_ moveAnimationLocationCell: MoveAnimationLocationCell, didUpdateAnimationLocation location: SCNVector3) {
        guard let animationIndex = dataSource?.animationIndex else { return }
        delegate?.moveAnimationAttributesView(self, didUpdateAnimationLocation: location, forAnimationAtIndex: animationIndex)
    }
}
