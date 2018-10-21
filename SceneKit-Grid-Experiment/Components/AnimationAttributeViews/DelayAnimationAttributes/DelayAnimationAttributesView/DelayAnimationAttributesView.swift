//
//  DelayAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol DelayAnimationAttributesViewDelegate: class {
    func delayAnimationAttributesView(_ delayAnimationAttributesView: DelayAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: DelayAnimationAttributes)
    func delayAnimationAttributesView(_ delayAnimationAttributesView: DelayAnimationAttributesView, didUpdateAnimationDelayDuration duration: TimeInterval, forAnimationAtIndex index: Int)
}

public class DelayAnimationAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 2
    private static let animationDurationCellHeight: CGFloat = 90.0
    private static let addAnimationCellHeight: CGFloat = 90.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Public Properties
    
    public weak var delegate: DelayAnimationAttributesViewDelegate?
    public var dataSource: DelayAnimationAttributes?
    
    // MARK: - Setup
    
    public init(delegate: DelayAnimationAttributesViewDelegate) {
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

extension DelayAnimationAttributesView: UITableViewDelegate {
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

extension DelayAnimationAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DelayAnimationAttributesView.numberOfItemsInSection
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
            return DelayAnimationAttributesView.animationDurationCellHeight
        case 1:
            return DelayAnimationAttributesView.addAnimationCellHeight
        default:
            return 60.0
        }
    }
}

// MARK: - AddAnimationCellDelegate

extension DelayAnimationAttributesView: AddAnimationCellDelegate {
    public func addAnimationCell(_ addAnimationCell: AddAnimationCell, didTapAddAnimationButton button: UIButton) {
        guard let animation = dataSource else { return }
        delegate?.delayAnimationAttributesView(self, didTapAddAnimationButton: button, animation: animation)
    }
}

// MARK: - AnimationDurationCellDelegate

extension DelayAnimationAttributesView: AnimationDurationCellDelegate {
    public func animationDurationCell(_ animationDurationCell: AnimationDurationCell, didUpdateAnimationDuration duration: TimeInterval) {
        dataSource?.duration = duration
        
        guard let animationIndex = dataSource?.animationIndex else { return }
        delegate?.delayAnimationAttributesView(self, didUpdateAnimationDelayDuration: duration, forAnimationAtIndex: animationIndex)
    }
}
