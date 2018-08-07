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
    
    /// Parses the current color to a dictionary with red, green, blue and alpha as keys.
    public func parseColor() -> [String : Float] {
        guard let components = self.cgColor.components else {
            fatalError("Node has no identifiable color.")
        }
        
        let red = components[0]
        let green = components[1]
        let blue = (components.count > 2 ? components[2] : green) // Crashes without this fix
        let alpha = self.cgColor.alpha
        
        return ["red": Float(red), "green": Float(green), "blue": Float(blue), "alpha": Float(alpha)]
    }
    
    /// Parses a dictionary which contains red, green, blue and alpha as keys and a Float of its respective values.
    public func parse(hex: [String : Float]) -> UIColor {
        guard let red = hex["red"],
              let green = hex["green"],
              let blue = hex["blue"],
              let alpha = hex["alpha"]
        else {
            return .white
        }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
