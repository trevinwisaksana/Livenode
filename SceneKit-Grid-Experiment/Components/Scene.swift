//
//  Scene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

public class Scene: NSObject, NSCoding {
    
    // MARK: - Internal Properties
    
    private static let backgroundColorKey = "colorKey"
    
    var backgroundColor: UIColor?
    
    // MARK: - Initialzer
    
    init?(scene: SCNScene?) {
        super.init()
        
        guard let scene = scene else {
            return nil
        }
        
        self.backgroundColor = scene.backgroundColor
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(backgroundColor?.parseColor(), forKey: Scene.backgroundColorKey)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        let hex = aDecoder.decodePropertyList(forKey: Scene.backgroundColorKey) as! [String : Float]
        self.backgroundColor = backgroundColor?.parse(hex: hex)
    }
    
}
