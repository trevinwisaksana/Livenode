//
//  NodeAnimationMenuViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 13/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

class NodeAnimationMenuViewControllerDelegate: NSObject, NodeAnimationMenuViewDelegate {
    func nodeAnimationMenuView(_ nodeAnimationMenuView: NodeAnimationMenuView, didSelectNodeAnimation animation: Animation) {
        NotificationCenter.default.post(name: Notification.Name.NodeAnimationMenuDidSelectAnimation, object: animation)
    }
}
