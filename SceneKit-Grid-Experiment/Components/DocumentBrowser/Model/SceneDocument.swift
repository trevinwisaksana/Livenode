//
//  SceneDocument.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit
import os.log

protocol SceneDocumentDelegate: class {
    func sceneDocumentUpdateContent(_ document: SceneDocument)
    func sceneDocumentTransferBegan(_ document: SceneDocument)
    func sceneDocumentTransferEnded(_ document: SceneDocument)
    func sceneDocumentSaveFailed(_ document: SceneDocument)
}

class SceneDocument: UIDocument {
    
    static let filenameExtension = "livenote"
    
    public var scene: DefaultScene = DefaultScene() {
        didSet {
            if let currentDelegate = delegate {
                currentDelegate.sceneDocumentUpdateContent(self)
            }
        }
    }
    
    public weak var delegate: SceneDocumentDelegate?
    public var loadProgress = Progress(totalUnitCount: 10)
    
    private var docStateObserver: Any?
    private var transfering: Bool = false
    
    override init(fileURL url: URL) {
        
        docStateObserver = nil
        super.init(fileURL: url)
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        docStateObserver = notificationCenter.addObserver(forName: UIDocument.stateChangedNotification, object: self, queue: mainQueue) { [weak self](_) in
            guard let doc = self else {
                return
            }
            
            doc.updateDocumentState()
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
        let decodedContent = unarchiver.decodeObject(of: DefaultScene.self, forKey: NSKeyedArchiveRootObjectKey)
        guard let content = decodedContent else {
            throw DocumentError.corruptDocument
        }
        
        scene = content
    }
    
    // MARK: - Private Methods
    
    private func updateDocumentState() {
        
        if documentState == .normal {
            os_log("=> Document entered normal state", log: OSLog.default, type: .debug)
        }
        
        if documentState.contains(.closed) {
            os_log("=> Document has closed", log: OSLog.default, type: .debug)
        }
        
        if documentState.contains(.editingDisabled) {
            os_log("=> Document's editing is disabled", log: OSLog.default, type: .debug)
        }
        
        if documentState.contains(.inConflict) {
            os_log("=> A document conflict was detected", log: OSLog.default, type: .debug)
            resolveDocumentConflict()
        }
        
        if documentState.contains(.savingError) {
            if let currentDelegate = delegate {
                currentDelegate.sceneDocumentSaveFailed(self)
            }
        }
        
        handleDocStateForTransfers()
    }
    
    private func handleDocStateForTransfers() {
        if transfering {
            // If we're in the middle of a transfer, check to see if the transfer has ended.
            if !documentState.contains(.progressAvailable) {
                transfering = false
                if let currentDelegate = delegate {
                    currentDelegate.sceneDocumentTransferEnded(self)
                }
            }
        } else {
            // If we're not in the middle of a transfer, check to see if a transfer has started.
            if documentState.contains(.progressAvailable) {
                os_log("=> A transfer is in progress", log: OSLog.default, type: .debug)
                
                if let currentDelegate = delegate {
                    currentDelegate.sceneDocumentTransferBegan(self)
                    transfering = true
                }
            }
        }
    }
    
    private func resolveDocumentConflict() {
        
        // To accept the current version, remove the other versions,
        // and resolve all the unresolved versions.
        
        do {
            try NSFileVersion.removeOtherVersionsOfItem(at: fileURL)
            
            if let conflictingVersions = NSFileVersion.unresolvedConflictVersionsOfItem(at: fileURL) {
                for version in conflictingVersions {
                    version.isResolved = true
                }
            }
        } catch let error {
            os_log("*** Error: %@ ***", log: OSLog.default, type: .error, error.localizedDescription)
        }
    }
    
}
