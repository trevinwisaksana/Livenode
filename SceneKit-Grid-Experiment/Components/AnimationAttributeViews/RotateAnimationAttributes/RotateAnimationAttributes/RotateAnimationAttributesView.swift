//
//  RotateAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol RotateAnimationAttributesViewDelegate: class {
    func rotateAnimationAttributesView(_ rotateAnimationAttributesView: RotateAnimationAttributesView, didUpdateAnimationDuration duration: Int)
    func rotateAnimationAttributesView(_ rotateAnimationAttributesView: RotateAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: RotateAnimationAttributes)
}

public class RotateAnimationAttributesDataSource: NSObject {
    var animationAttributes = RotateAnimationAttributes()
}

public class RotateAnimationAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 3
    private static let animationDurationCellHeight: CGFloat = 90.0
    private static let rotateAnimationAngleCellHeight: CGFloat = 60.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private weak var delegate: RotateAnimationAttributesViewDelegate?
    private var dataSource = RotateAnimationAttributesDataSource()
    
    // MARK: - Setup
    
    public init(delegate: RotateAnimationAttributesViewDelegate) {
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
        tableView.register(cell: AddAnimationCell.self)
        
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension RotateAnimationAttributesView: UITableViewDelegate {
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

extension RotateAnimationAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RotateAnimationAttributesView.numberOfItemsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: AnimationDurationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            cell.model = dataSource.animationAttributes
            
            return cell
            
        case 1:
            let cell: RotateAnimationAngleCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            return cell
            
        case 2:
            let cell: AddAnimationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            return cell
            
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return RotateAnimationAttributesView.animationDurationCellHeight
        case 1:
            return RotateAnimationAttributesView.rotateAnimationAngleCellHeight
        default:
            return 60.0
        }
    }
}

// MARK: - AddAnimationCellDelegate

extension RotateAnimationAttributesView: AddAnimationCellDelegate {
    public func addAnimationCell(_ addAnimationCell: AddAnimationCell, didTapAddAnimationButton button: UIButton) {
        delegate?.rotateAnimationAttributesView(self, didTapAddAnimationButton: button, animation: dataSource.animationAttributes)
    }
}

// MARK: - AnimationDurationCellDelegate

extension RotateAnimationAttributesView: AnimationDurationCellDelegate {
    public func animationDurationCell(_ animationDurationCell: AnimationDurationCell, didUpdateAnimationDuration duration: TimeInterval) {
        dataSource.animationAttributes.duration = duration
    }
}

// MARK: - RotateAnimationAngleCellDelegate

extension RotateAnimationAttributesView: RotateAnimationAngleCellDelegate {
    public func rotateAnimationAngleCell(_ rotateAnimationAngleCell: RotateAnimationAngleCell, didUpdateRotationAngle angle: CGFloat) {
        dataSource.animationAttributes.angle = angle
    }
}