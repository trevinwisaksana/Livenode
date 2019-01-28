//
//  OnboardingWalkthroughView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 12/01/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class OnboardingPopView: UIPopoverBackgroundView {
    
    override var arrowOffset: CGFloat {
        get {
            return 0.0
        }
        
        set {}
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return .up
        }
        
        set {}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        layer.shadowColor = UIColor.clear.cgColor
        layer.cornerRadius = 5.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0, right: 0.0)
    }
    
    override class func arrowHeight() -> CGFloat {
        return 50.0
    }
    
    override class func arrowBase() -> CGFloat {
        return 25.0
    }
    
}
