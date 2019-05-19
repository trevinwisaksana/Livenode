//
//  DocumentBrowserManager.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

final class DocumentBrowserManager: NSObject, UIDocumentBrowserViewControllerDelegate {
    
    // MARK: - Delegate Methods
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let url = createDocumentURL()
        let document = SceneDocument(fileURL: url)
        
        document.save(to: url, for: .forCreating) { (success) in
            guard success else {
                importHandler(nil, .none)
                return
            }
            
            document.close { (success) in
                guard success else {
                    importHandler(nil, .none)
                    return
                }
                
                self.openDocument(with: url, using: controller)

                importHandler(url, .move)
            }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let documentSelectedURL = documentURLs.first else {
            return
        }
        
        openDocument(with: documentSelectedURL, using: controller)
    }
}

// MARK: - Opening Document

extension DocumentBrowserManager {
    private func openDocument(with url: URL, using controller: UIDocumentBrowserViewController) {
        if isDocumentOpen(with: url) {
            return
        }
        
        let document = SceneDocument(fileURL: url)
        document.open { (openSuccess) in
            if !openSuccess {
                print("Failed to open document.")
                return
            }
            
            State.currentDocument = document
            self.displayDocument(with: controller)
        }
    }
    
    private func displayDocument(with controller: UIDocumentBrowserViewController) {
        guard let document = State.currentDocument else {
            return
        }
        
        if State.isEditingScene {
            return
        }
        
        State.isEditingScene = true
        
        let sceneEditor = SceneEditorViewController(sceneDocument: document, delegate: self)
        let navigationController = RootNavigationController(rootViewController: sceneEditor)
        controller.present(navigationController, animated: true, completion: nil)
    }
    
    private func isDocumentOpen(with url: URL) -> Bool {
        if let document = State.currentDocument {
            if document.fileURL == url && document.documentState != .closed  {
                return true
            }
        }
        
        return false
    }
}


// MARK: - Document Creation

extension DocumentBrowserManager {
    private func createDocumentURL() -> URL {
        let documentPath = UIApplication.cacheDirectory()
        let documentURL = documentPath.appendingPathComponent("Blank").appendingPathExtension(SceneDocument.filenameExtension)
        return documentURL
    }
}

// MARK: - SceneEditorDelegate

extension DocumentBrowserManager: SceneEditorDocumentDelegate {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: DefaultScene) {
        State.currentDocument?.scene = scene
        State.currentDocument?.updateChangeCount(.done)
        
        State.currentDocument?.close(completionHandler: { (success) in
            guard success else {
                fatalError( "Error saving document.")
            }
            
            State.currentDocument = nil
            State.isEditingScene = false
        })
    }
}
