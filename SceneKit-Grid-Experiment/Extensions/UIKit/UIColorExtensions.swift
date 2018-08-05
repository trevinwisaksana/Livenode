//
//  UIColorExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UIColor {
    public class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }
    
    public class var aluminium: UIColor {
        return UIColor(r: 248, g: 248, b: 255)!
    }
    
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    var hex: UInt {
        let red = UInt(ciColor.red * 255 + 0.5)
        let green = UInt(ciColor.green * 255 + 0.5)
        let blue = UInt(ciColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
}
