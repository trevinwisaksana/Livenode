//
//  NodeInspectorViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol NodeInspectorDelegate: class {
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didSelectItemAtIndexPath indexPath: IndexPath)
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdateNodePosition position: SCNVector3)
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didAngleNodePosition angle: Float)
    
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdatePlaneWidth width: CGFloat)
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdatePlaneLength length: CGFloat)
    func nodeInspector(_ nodeInspector: NodeInspectorViewController, didUpdateNodeColor color: UIColor)
}

final class NodeInspectorViewController: UIViewController {
    
    // MARK: - External Properties
    
    weak var delegate: NodeInspectorDelegate?
    
    // MARK: - Internal Properties
    
    private let popoverWidth: Int = Style.navigationItemPopoverWidth
    private let popoverHeight: Int = 300
    
    lazy var mainView: NodeInspectorParentView = {
        let mainView = NodeInspectorParentView(frame: .zero)
        mainView.delegate = self
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mainView.inspectorView.reloadData()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
        
        title = ""
        preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
    }
}

// MARK: - NodeInspectorPresentableViewDelegate

extension NodeInspectorViewController: NodeInspectorParentViewDelegate {
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didSelectItemAtIndexPath indexPath: IndexPath) {
        delegate?.nodeInspector(self, didSelectItemAtIndexPath: indexPath)
    }
    
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didUpdateNodeColor color: UIColor) {
        delegate?.nodeInspector(self, didUpdateNodeColor: color)
    }
    
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didUpdateNodePosition position: SCNVector3) {
        delegate?.nodeInspector(self, didUpdateNodePosition: position)
    }
    
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didAngleNodePosition angle: Float) {
        delegate?.nodeInspector(self, didAngleNodePosition: angle)
    }
    
    // MARK: - PlaneNodeInspectorDelegate
    
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didUpdatePlaneWidth width: CGFloat) {
        delegate?.nodeInspector(self, didUpdatePlaneWidth: width)
    }
    
    func nodeInspectorParentView(_ nodeInspectorParentView: NodeInspectorParentView, didUpdatePlaneLength length: CGFloat) {
        delegate?.nodeInspector(self, didUpdatePlaneLength: length)
    }
}
