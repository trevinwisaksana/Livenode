//
//  NodeAnimationMenuView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol NodeAnimationListViewDelegate: class {
    func nodeAnimationListView(_ nodeAnimationListView: NodeAnimationListView, didSelectNodeAnimation animation: Animation)
}

public class NodeAnimationListViewDataSource: NSObject {
    let nodeAnimations: [SCNAction] = State.nodeAnimationTarget?.actions ?? []
}

public class NodeAnimationListView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
    lazy var dataSource: NodeAnimationListViewDataSource = {
        return NodeAnimationListViewDataSource()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private weak var delegate: NodeAnimationListViewDelegate?
    
    // MARK: - Setup
    
    public init(delegate: NodeAnimationListViewDelegate) {
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
        tableView.register(cell: NodeAnimationListCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension NodeAnimationListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectNodeAnimation(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let movedAnimation = State.nodeAnimationTarget?.actions[sourceIndexPath.row] {
            State.nodeAnimationTarget?.actions.remove(at: sourceIndexPath.row)
            State.nodeAnimationTarget?.actions.insert(movedAnimation, at: destinationIndexPath.row)
        }
    }
    
    private func didSelectNodeAnimation(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NodeAnimationListCell
        let animation = dataSource.nodeAnimations[indexPath.row]
        
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }

        switch cell.animationType {
        case .move:
            let animationAttributes = MoveAnimationAttributes(duration: animation.duration, targetLocation: animation.targetLocation, animationIndex: indexPath.row)
            let moveAnimationAttributes = Presenter.inject(.moveAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(moveAnimationAttributes, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .move)
            
        case .rotate:
            let animationAttributes = RotateAnimationAttributes(duration: animation.duration, angle: animation.rotationAngle)
            let rotateAnimationAttributesController = Presenter.inject(.rotateAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(rotateAnimationAttributesController, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .rotate)
            
        default:
            break
        }
    }
    
    public func tableViewIsEditing() -> Bool {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
        
        return tableView.isEditing
    }
}

// MARK: - UITableViewDataSource

extension NodeAnimationListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.nodeAnimations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        let cell: NodeAnimationListCell = tableView.dequeueReusableCell()
        
        let animationType = dataSource.nodeAnimations[indexPath.row].animationType
        cell.animationType = animationType
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeAnimationListView.cellHeight
    }
}
