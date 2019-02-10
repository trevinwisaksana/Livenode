//
//  UIColorExtensions.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Custom Colors
    
    public class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }
    
    public class var aluminium: UIColor {
        return UIColor(r: 248, g: 248, b: 255)!
    }
    
    public class var lavender: UIColor {
        return UIColor(r: 106, g: 84, b: 227)!
    }
    
    public class var utilityBlue: UIColor {
        return UIColor(r: 0, g: 162, b: 255)!
    }
    
    public class var skyBlue: UIColor {
        return UIColor(r: 93, g: 205, b: 255)!
    }
    
    public class var dark: UIColor {
        return UIColor(r: 29, g: 29, b: 29)!
    }
    
    // MARK: - Convenience Initializer
    
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // MARK: - Color Conversion
    
    /// Parses the current color to a dictionary with red, green, blue and alpha as keys.
    public func toRGBA() -> [String : Float] {
        guard let components = self.cgColor.components else {
            fatalError("Node has no identifiable color.")
        }
        
        let rgba = components.map { (value) in
           return Float(value)
        }
        
        let red = rgba[0]
        let green = rgba[1]
        let blue = (rgba.count > 2 ? rgba[2] : green)
        let alpha = Float(self.cgColor.alpha)
        
        return ["red": red, "green": green, "blue": blue, "alpha": alpha]
    }
    
    /// Parses a dictionary which contains red, green, blue and alpha as keys and Floats as its respective values.
    static func parse(hex: [String : Float]) -> UIColor {
        guard let red = hex["red"],
              let green = hex["green"],
              let blue = hex["blue"],
              let alpha = hex["alpha"]
        else {
            fatalError("Failed to decode color.")
        }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
