//
//  EasyTipViewExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Stockbit on 29/01/19.
//  Copyright © 2019 Trevin Wisaksana. All rights reserved.
//

import EasyTipView

extension EasyTipView {
    
    static func toolTipPopupViewPreference() -> EasyTipView.Preferences {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.textAlignment = .center
        
        preferences.drawing.backgroundColor = .yellow
        preferences.drawing.foregroundColor = .black
        
        preferences.positioning.maxWidth = 500.0
        
        preferences.drawing.arrowHeight = 0.0
        preferences.drawing.arrowWidth = 0.0
        preferences.drawing.arrowPosition = .top
        
        return preferences
    }
    
}
