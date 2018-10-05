//
//  State.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 31/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import SceneKit

struct State {
    private static let currentSceneKey: String = "currentSceneKey"
    
    static var currentDocument: SceneDocument?
    static var isEditingScene: Bool = false
    static var nodeSelected: Node?
    
    
//    static var currentScene: Scene? {
//        get {
//            guard let encodedScene = UserDefaults.standard.data(forKey: currentSceneKey) else {
//                fatalError("Failed to retrieve scene data.")
//            }
//
//            let scene = NSKeyedUnarchiver.unarchiveObject(with: encodedScene) as? Scene
//
//            return scene
//        }
//        set {
//            if let scene = newValue {
//                UserDefaults.standard.removeObject(forKey: currentSceneKey)
//
//                let data = NSKeyedArchiver.archivedData(withRootObject: scene)
//                UserDefaults.standard.set(data, forKey: currentSceneKey)
//            }
//        }
//    }
}
