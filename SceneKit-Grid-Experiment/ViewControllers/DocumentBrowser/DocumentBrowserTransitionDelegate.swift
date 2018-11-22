//
//  DocumentBrowserTransitionDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 22/11/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

class DocumentBrowserTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let transitionController: UIDocumentBrowserTransitionController
    
    init(withTransitionController transitionController: UIDocumentBrowserTransitionController) {
        self.transitionController = transitionController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}
