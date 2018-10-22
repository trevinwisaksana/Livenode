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

public class NodeAnimationListView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    
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
        let animation = State.nodeAnimationTarget?.actions[indexPath.row]
        
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }

        switch cell.animationType {
        case .move:
            guard let targetLocation = animation?.targetLocation else { return }
            
            let animationAttributes = MoveAnimationAttributes(duration: animation?.duration, targetLocation: targetLocation, animationIndex: indexPath.row)
            let moveAnimationAttributes = Presenter.inject(.moveAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(moveAnimationAttributes, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .move)
            
        case .rotate:
            let animationAttributes = RotateAnimationAttributes(duration: animation?.duration, angle: animation?.rotationAngle, animationIndex: indexPath.row)
            let rotateAnimationAttributesController = Presenter.inject(.rotateAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(rotateAnimationAttributesController, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .rotate)
            
        case .delay:
            let animationAttributes = DelayAnimationAttributes(duration: animation?.duration, animationIndex: indexPath.row)
            let delayAnimationAttributesController = Presenter.inject(.delayAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(delayAnimationAttributesController, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .delay)
            
        case .alert:
            guard let animatedNodeLocation = State.nodeAnimationTarget?.position else { return }
            
            let animationAttributes = AlertAnimationAttributes(duration: animation?.duration, animationIndex: indexPath.row, nodeLocation: animatedNodeLocation)
            let alertAnimationAttributesController = Presenter.inject(.alertAnimationAttributes(attributes: animationAttributes))
            navigationController.pushViewController(alertAnimationAttributesController, animated: true)
            
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .alert)
            
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
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            State.nodeAnimationTarget?.actions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension NodeAnimationListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return State.nodeAnimationTarget?.actions.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        let cell: NodeAnimationListCell = tableView.dequeueReusableCell()
        
        let animationType = State.nodeAnimationTarget?.actions[indexPath.row].animationType
        cell.animationType = animationType ?? .default
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeAnimationListView.cellHeight
    }
}
