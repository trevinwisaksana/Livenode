//
//  SceneDocument.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SceneDocument: UIDocument {
    
    static let defaultSceneTemplate = ""
    static let filenameExtension = "scn"
    
    var scene: Scene = Scene(scene: DefaultScene()) {
        didSet {
            updateChangeCount(.done)
        }
    }
    
    override func contents(forType typeName: String) throws -> Any {
        let data: Data
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: false)
        } catch {
            throw DocumentError.archivingFailure
        }
        guard !data.isEmpty else {
            throw DocumentError.archivingFailure
        }
        return data
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else {
            throw DocumentError.unrecognizedContent
        }
        
        let unarchiver: NSKeyedUnarchiver
        do {
            unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        } catch {
            throw DocumentError.corruptDocument
        }
        unarchiver.requiresSecureCoding = false
        let decodedContent = unarchiver.decodeObject(of: Scene.self, forKey: NSKeyedArchiveRootObjectKey)
        guard let content = decodedContent else {
            throw DocumentError.corruptDocument
        }
        
        scene = content
    }
}
