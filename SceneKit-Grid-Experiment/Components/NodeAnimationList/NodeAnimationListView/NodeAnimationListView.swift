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
    func nodeAnimationListView(_ nodeAnimationListView: NodeAnimationListView, didSelectNodeAnimation animation: Animation, atIndex index: Int)
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
    
    // MARK: - External Properties
    
    public weak var delegate: NodeAnimationListViewDelegate?
    
    // MARK: - Setup
    
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
        
        let animationType = State.nodeAnimationTarget?.actions[indexPath.row].animationType()
        cell.animationType = animationType ?? .default
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeAnimationListView.cellHeight
    }
}

// MARK: - UITableViewDelegate

extension NodeAnimationListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        didSelectNodeAnimation(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let movedAnimation = State.nodeAnimationTarget?.actions[sourceIndexPath.row] {
            State.nodeAnimationTarget?.actions.remove(at: sourceIndexPath.row)
            State.nodeAnimationTarget?.actions.insert(movedAnimation, at: destinationIndexPath.row)
        }
    }
    
    private func didSelectNodeAnimation(at indexPath: IndexPath) {
        guard let animationType = (tableView.cellForRow(at: indexPath) as? NodeAnimationListCell)?.animationType else {
            return
        }
        
        switch animationType {
        case .move:
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .move, atIndex: indexPath.row)
            
        case .rotate:
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .rotate, atIndex: indexPath.row)
            
        case .delay:
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .delay, atIndex: indexPath.row)
            
        case .speechBubble:
            delegate?.nodeAnimationListView(self, didSelectNodeAnimation: .speechBubble, atIndex: indexPath.row)
            
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
    
    public func tableViewIsEmpty() -> Bool {
        if tableView.numberOfRows(inSection: 0) == 0 {
            return true
        }
        
        return false
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
