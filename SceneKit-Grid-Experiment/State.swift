//
//  State.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

struct State {
    private static let nodeSelectedKey: String = "nodeSelectedKey"
    private static let currentSceneKey: String = "currentSceneKey"
    
    static var nodeSelected: Node? {
        get {
            guard let encodedNode = UserDefaults.standard.data(forKey: nodeSelectedKey) else {
                fatalError("Failed to retrieve node data.")
            }
            
            let node = NSKeyedUnarchiver.unarchiveObject(with: encodedNode) as? Node
            
            return node
        }
        set {
            // Only set when nodeSelected has its value replaced
            if let node = newValue {
                UserDefaults.standard.removeObject(forKey: nodeSelectedKey)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: node)
                UserDefaults.standard.set(data, forKey: nodeSelectedKey)
            }
        }
    }
    
    static var currentScene: Scene? {
        get {
            guard let encodedScene = UserDefaults.standard.data(forKey: currentSceneKey) else {
                fatalError("Failed to retrieve scene data.")
            }
            
            let scene = NSKeyedUnarchiver.unarchiveObject(with: encodedScene) as? Scene
            
            return scene
        }
        set {
            if let scene = newValue {
                UserDefaults.standard.removeObject(forKey: currentSceneKey)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: scene)
                UserDefaults.standard.set(data, forKey: currentSceneKey)
            }
        }
    }
}
