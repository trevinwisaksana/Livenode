//
//  DocumentBrowserDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

class DocumentBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate {
    
    // MARK: - Internal Properties
    
    private static let documentNumberKey = "documentNumberKey"
    
    // MARK: - Public Properties
    
    public var presentationHandler: ((URL?, Error?) -> Void)?
    
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
        // TODO: Remove the storyboard implementation
        let storybard = UIStoryboard(name: "Main", bundle: .main)
        let sceneViewController = storybard.instantiateViewController(withIdentifier: "SceneViewController")
        controller.navigationController?.pushViewController(sceneViewController, animated: true)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentationHandler?(destinationURL, nil)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        presentationHandler?(documentURL, error)
    }
}

// MARK: - Opening Document

extension DocumentBrowserDelegate {
    private func openDocument(with url: URL) {
        if !isDocumentOpen(with: url) {
            return
        }
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

extension DocumentBrowserDelegate {
    private func createDefaultDocumentName() -> String {
        let newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.documentNumberKey)
        
        if newDocumentNumber == 0 {
            return "Blank"
        } else {
            return "Blank \(newDocumentNumber)"
        }
    }
    
    private func incrementDocumentNameCount() {
        // TODO: Decrement document name count when deleting document
        var newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.documentNumberKey) + 1
        
        if newDocumentNumber == 1 {
            newDocumentNumber += 1
        }
        
        UserDefaults.standard.set(newDocumentNumber, forKey: DocumentBrowserDelegate.documentNumberKey)
    }
    
    func createDocumentURL() -> URL {
        let documentPath = UIApplication.cacheDirectory()
        let documentName = createDefaultDocumentName()
        let documentURL = documentPath.appendingPathComponent(documentName).appendingPathExtension(SceneDocument.filenameExtension)
        
        incrementDocumentNameCount()
        return documentURL
    }
}
