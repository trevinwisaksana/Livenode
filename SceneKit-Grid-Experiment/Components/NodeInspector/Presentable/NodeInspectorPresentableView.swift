//
//  NodeInspectorPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol NodeInspectorPresentableViewDelegate: class {
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didSelectItemAtIndexPath indexPath: IndexPath)
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didUpdateNodePosition position: SCNVector3)
}

public class NodeDataSource: NSObject {
    let node: NodeInspectorViewModel? = State.nodeSelected
}

public class NodeInspectorPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: NodeDataSource = {
        return NodeDataSource()
    }()
    
    lazy var inspectorView: NodeInspectorView = {
        let view = NodeInspectorView(delegate: self, dataSource: self)
        return view
    }()
    
    // MARK: - Public properties
    
    weak var delegate: NodeInspectorPresentableViewDelegate?
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        addSubview(inspectorView)
        inspectorView.fillInSuperview()
    }
}

// MARK: - NodeInspectorViewDelegate

extension NodeInspectorPresentableView: NodeInspectorViewDelegate {
    public func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didSelectItemAtIndexPath indexPath: IndexPath) {
        transition(using: indexPath)
    }
    
    private func transition(using indexPath: IndexPath) {
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }
        
        switch indexPath.row {
        case 0:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController.pushViewController(colorPicker, animated: true)
        default:
            break
        }
    }
    
    public func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didUpdateNodePosition position: SCNVector3) {
        delegate?.nodeInspectorPresentableView(self, didUpdateNodePosition: position)
    }
}

// MARK: - NodeInspectorViewDataSource

extension NodeInspectorPresentableView: NodeInspectorViewDataSource {
    public func viewModel(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> NodeInspectorViewModel {
        return NodeInspector(color: dataSource.node?.color ?? .clear, angle: dataSource.node?.angle ?? SCNVector3Zero, position: dataSource.node?.position ?? SCNVector3Zero)
    }
}
