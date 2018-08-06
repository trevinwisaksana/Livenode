//
//  State.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

struct State {
    private static let nodeSelectedKey = "nodeSelectedKey"
    private static let currentSceneKey = "currentSceneKey"
    
    static var nodeSelected: Node? {
        get {
            guard let encodedNode = UserDefaults.standard.data(forKey: nodeSelectedKey) else {
                fatalError("Failed to retrieve node data.")
            }
            
            let node = NSKeyedUnarchiver.unarchiveObject(with: encodedNode) as? Node
            
            return node
        }
        set {
            if let node = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: node)
                UserDefaults.standard.set(data, forKey: nodeSelectedKey)
            } else {
                UserDefaults.standard.removeObject(forKey: nodeSelectedKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currentScene: SCNScene? {
        get {
            guard let scene = UserDefaults.standard.object(forKey: currentSceneKey) as? SCNScene else { return nil }
            return scene
        }
        set {
            if let scene = newValue {
                UserDefaults.standard.set(scene, forKey: currentSceneKey)
            } else {
                UserDefaults.standard.removeObject(forKey: currentSceneKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}
