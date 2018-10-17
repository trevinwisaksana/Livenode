//
//  RotateAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 17/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol RotateAnimationAttributesViewDelegate: class {
    func rotateAniamtionAttributesView(_ rotateAniamtionAttributesView: RotateAniamtionAttributesView, didUpdateAnimationDuration duration: Int)
    func rotateAniamtionAttributesView(_ rotateAniamtionAttributesView: RotateAniamtionAttributesView, didTapAddAnimationButton button: UIButton)
}

public class RotateAniamtionAttributesView: UIView {
    
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
        return tableView
    }()
    
    private weak var delegate: RotateAnimationAttributesViewDelegate?
    
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
            return RotateAniamtionAttributesView.animationDurationCellHeight
        case 1:
            return RotateAniamtionAttributesView.rotateAnimationAngleCellHeight
        default:
            return 60.0
        }
    }
}

// MARK: - AddAnimationCellDelegate

extension RotateAniamtionAttributesView: AddAnimationCellDelegate {
    public func didTapAddAnimationButton(_ sender: UIButton) {
        delegate?.rotateAniamtionAttributesView(self, didTapAddAnimationButton: sender)
    }
}
