//
//  NodeInspectorPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class NodeDataSource: NSObject {
    let node: SCNNode? = State.nodeSelected
}

public class NodeInspectorPresentableView: UIView {
    lazy var dataSource: NodeDataSource = {
        return NodeDataSource()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = NodeInspectorView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - NodeInspectorViewDelegate

extension NodeInspectorPresentableView: NodeInspectorViewDelegate {
    public func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didSelectItemAtIndexPath indexPath: IndexPath) {
        transition(using: indexPath)
    }
    
    private func transition(using indexPath: IndexPath) {
        let viewController: UIViewController
        
        switch indexPath.section {
        case 0:
            break
        default:
            break
        }
    }
}

// MARK: - NodeInspectorViewDataSource

extension NodeInspectorPresentableView: NodeInspectorViewDataSource {
    public func viewModel(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> NodeInspectorViewModel {
        return NodeInspector(node: dataSource.node)
    }
}
