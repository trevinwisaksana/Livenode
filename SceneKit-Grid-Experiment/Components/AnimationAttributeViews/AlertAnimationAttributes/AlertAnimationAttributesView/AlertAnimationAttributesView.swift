//
//  AlertAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol AlertAnimationAttributesViewDelegate: class {
    func alertAnimationAttributesView(_ alertAnimationAttributesView: AlertAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: AlertAnimationAttributes)
    func alertAnimationAttributesView(_ alertAnimationAttributesView: AlertAnimationAttributesView, didUpdateAnimationDuration duration: TimeInterval, forAnimationAtIndex index: Int)
}

public class AlertAnimationAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private static let numberOfItemsInSection: Int = 2
    private static let animationDurationCellHeight: CGFloat = 90.0
    private static let addAnimationCellHeight: CGFloat = 60.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Public Properties
    
    public weak var delegate: AlertAnimationAttributesViewDelegate?
    public var dataSource: AlertAnimationAttributes?
    
    // MARK: - Setup
    
    public init(delegate: AlertAnimationAttributesViewDelegate) {
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

extension AlertAnimationAttributesView: UITableViewDelegate {
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

extension AlertAnimationAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlertAnimationAttributesView.numberOfItemsInSection
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
            return AlertAnimationAttributesView.animationDurationCellHeight
        case 1:
            return AlertAnimationAttributesView.addAnimationCellHeight
        default:
            return 60.0
        }
    }
}

// MARK: - AddAnimationCellDelegate

extension AlertAnimationAttributesView: AddAnimationCellDelegate {
    public func addAnimationCell(_ addAnimationCell: AddAnimationCell, didTapAddAnimationButton button: UIButton) {
        guard let animatedNodeLocation = State.nodeAnimationTarget?.position else { return }
        dataSource?.nodeLocation = animatedNodeLocation
        
        guard let dataSource = dataSource else { return }
        
        delegate?.alertAnimationAttributesView(self, didTapAddAnimationButton: button, animation: dataSource)
    }
}

// MARK: - AnimationDurationCellDelegate

extension AlertAnimationAttributesView: AnimationDurationCellDelegate {
    public func animationDurationCell(_ animationDurationCell: AnimationDurationCell, didUpdateAnimationDuration duration: TimeInterval) {
        dataSource?.duration = duration
        
        guard let animationIndex = dataSource?.animationIndex else { return }
        delegate?.alertAnimationAttributesView(self, didUpdateAnimationDuration: duration, forAnimationAtIndex: animationIndex)
    }
}
