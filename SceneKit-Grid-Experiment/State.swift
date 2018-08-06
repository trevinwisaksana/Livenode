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
            UserDefaults.standard.removeObject(forKey: nodeSelectedKey)
            
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
            }
        }
    }
    
    static var currentScene: Scene? {
        get {
            guard let scene = UserDefaults.standard.object(forKey: currentSceneKey) as? Scene else { return nil }
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
