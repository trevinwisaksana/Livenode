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
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didAngleNodePosition angle: Float)
    
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didUpdatePlaneWidth width: CGFloat)
    func nodeInspectorPresentableView(_ nodeInspectorPresentableView: NodeInspectorPresentableView, didUpdatePlaneLength length: CGFloat)
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
        guard let type = dataSource.node?.type else {
            fatalError("Cannot determine the type of the node.")
        }
        
        switch type {
        case .plane:
            let view = PlaneNodeInspectorView(delegate: self, dataSource: self)
            return view
        default:
            let view = NodeInspectorView(delegate: self, dataSource: self)
            return view
        }
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
        // TODO: Avoid accessing parent view controller
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }
        
        switch indexPath.row {
        case 0:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController.pushViewController(colorPicker, animated: true)
        case 3:
            // TODO: Show the animation navigation item
            break
//            let nodeAnimationList = Presenter.inject(.nodeAnimationList)
//            navigationController.pushViewController(nodeAnimationList, animated: true)
        default:
            break
        }
    }
    
    public func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didUpdateNodePosition position: SCNVector3) {
        delegate?.nodeInspectorPresentableView(self, didUpdateNodePosition: position)
    }
    
    public func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didAngleNodePosition angle: Float) {
        delegate?.nodeInspectorPresentableView(self, didAngleNodePosition: angle)
    }
    
    public func planeNodeInspectorView(_ planeNodeInspectorView: PlaneNodeInspectorView, didUpdatePlaneLength length: CGFloat) {
        delegate?.nodeInspectorPresentableView(self, didUpdatePlaneLength: length)
    }
    
    public func planeNodeInspectorView(_ planeNodeInspectorView: PlaneNodeInspectorView, didUpdatePlaneWidth width: CGFloat) {
        delegate?.nodeInspectorPresentableView(self, didUpdatePlaneWidth: width)
    }
}

// MARK: - NodeInspectorViewDataSource

extension NodeInspectorPresentableView: NodeInspectorViewDataSource {
    public func viewModel(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> NodeInspectorViewModel? {
        guard let node = dataSource.node else {
            return nil
        }
        
        return NodeInspector(color: node.color, angle: node.angle, position: node.position, type: node.type, width: node.width, length: node.length)
    }
}
