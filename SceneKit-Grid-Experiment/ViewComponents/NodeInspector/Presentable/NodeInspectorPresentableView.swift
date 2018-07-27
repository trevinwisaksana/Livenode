//
//  NodeInspectorPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class NodeDataSource: NSObject {
    // TODO: Add View Model
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
        
    }
    
    private func transition(fromSection section: Int) {
        let viewController: UIViewController
        
        switch section {
        case 0:
            break
        default:
            break
        }
    }
}

// MARK: - NodeInspectorViewDataSource

extension NodeInspectorPresentableView: NodeInspectorViewDataSource {
    public func numberOfItems(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> Int {
        return 1
    }
}
