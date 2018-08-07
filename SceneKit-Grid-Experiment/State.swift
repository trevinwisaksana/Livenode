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
            
            UserDefaults.standard.removeObject(forKey: nodeSelectedKey)
            
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
            guard let encodedScene = UserDefaults.standard.data(forKey: currentSceneKey) else {
                fatalError("Failed to retrieve scene data.")
            }
            
            UserDefaults.standard.removeObject(forKey: currentSceneKey)
            
            let scene = NSKeyedUnarchiver.unarchiveObject(with: encodedScene) as? Scene
            
            return scene
        }
        set {
            if let scene = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: scene)
                UserDefaults.standard.set(data, forKey: currentSceneKey)
            }
        }
    }
}
