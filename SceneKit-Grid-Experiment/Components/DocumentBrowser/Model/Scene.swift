//
//  Scene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit
import UIKit

public class Scene: NSObject, NSCoding, SceneViewModel {
    
    // MARK: - Internal Properties
    
    private static let backgroundColorKey: String = "backgroundColorKey"
    private static let floorColorKey: String = "floorColorKey"
    
    public var backgroundColor: UIColor = .white
    public var floorColor: UIColor = .gray
    
    // MARK: - Initialzer
    
    init(template: String) {
        super.init()
        
//        self.backgroundColor = scene.backgroundColor
//        self.floorColor = scene.floorColor
    }
    
    // MARK: - Encoder
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(backgroundColor.toRGBA(), forKey: Scene.backgroundColorKey)
        aCoder.encode(floorColor.toRGBA(), forKey: Scene.floorColorKey)
    }
    
    // MARK: - Decoder
    
    required public init?(coder aDecoder: NSCoder) {
        let backgroundColorHex = aDecoder.decodeObject(forKey: Scene.backgroundColorKey) as! [String : Float]
        self.backgroundColor = UIColor.parse(hex: backgroundColorHex)
        
        let floorColorHex = aDecoder.decodeObject(forKey: Scene.floorColorKey) as! [String : Float]
        self.floorColor = UIColor.parse(hex: floorColorHex)
    }
}
