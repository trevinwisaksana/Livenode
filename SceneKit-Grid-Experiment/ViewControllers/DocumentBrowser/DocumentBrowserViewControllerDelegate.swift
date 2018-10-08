//
//  DocumentBrowserViewControllerDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

class DocumentBrowserViewControllerDelegate: NSObject, UIDocumentBrowserViewControllerDelegate {
    
    // MARK: - Internal Properties
    
    private static let documentNumberKey = "documentNumberKey"
    
    // MARK: - Delegate Methods
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let url = createDocumentURL()
        let document = SceneDocument(fileURL: url)
        
        document.save(to: url, for: .forCreating) { (isSavedSuccessfuly) in
            if !isSavedSuccessfuly {
                importHandler(nil, .none)
                return
            }
            
            document.close { (isClosedSuccessfully) in
                if !isClosedSuccessfully {
                    importHandler(nil, .none)
                    return
                }

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
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        
    }
}

// MARK: - Opening Document

extension DocumentBrowserViewControllerDelegate {
    private func openDocument(with url: URL, using controller: UIDocumentBrowserViewController) {
        if isDocumentOpen(with: url) {
            return
        }
        
        let document = SceneDocument(fileURL: url)
        document.open { (openSuccess) in
            if !openSuccess {
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
        controller.navigationController?.pushViewController(sceneEditor, animated: true)
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

extension DocumentBrowserViewControllerDelegate {
    private func createDefaultDocumentName() -> String {
        let newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserViewControllerDelegate.documentNumberKey)
        
        if newDocumentNumber == 0 {
            return "Blank"
        } else {
            return "Blank \(newDocumentNumber)"
        }
    }
    
    private func incrementDocumentNameCount() {
        // TODO: Decrement document name count when deleting document
        var newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserViewControllerDelegate.documentNumberKey) + 1
        
        if newDocumentNumber == 1 {
            newDocumentNumber += 1
        }
        
        UserDefaults.standard.set(newDocumentNumber, forKey: DocumentBrowserViewControllerDelegate.documentNumberKey)
    }
    
    private func createDocumentURL() -> URL {
        let documentPath = UIApplication.cacheDirectory()
        let documentName = createDefaultDocumentName()
        let documentURL = documentPath.appendingPathComponent(documentName).appendingPathExtension(SceneDocument.filenameExtension)
        
        incrementDocumentNameCount()
        return documentURL
    }
}

// MARK: - SceneEditorDelegate

extension DocumentBrowserViewControllerDelegate: SceneEditorDelegate {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: SCNScene) {
        State.isEditingScene = false
        State.currentDocument = nil
    }
    
    func sceneEditor(_ controller: SceneEditorViewController, didUpdateContent scene: SCNScene) {
        
    }
}
