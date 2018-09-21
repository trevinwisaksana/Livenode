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
        let cacheURL = createDocumentURL()
        let document = SceneDocument(fileURL: cacheURL)
        
        document.save(to: cacheURL, for: .forCreating) { (isSavedSuccessfuly) in
            if !isSavedSuccessfuly {
                importHandler(nil, .none)
                return
            }
            
            document.close { (isClosedSuccessfully) in
                if !isClosedSuccessfully {
                    importHandler(nil, .none)
                    return
                }
                
                importHandler(cacheURL, .move)
            }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let selectedURL = documentURLs.first else {
            return
        }
        presentationHandler?(selectedURL, nil)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentationHandler?(destinationURL, nil)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        presentationHandler?(documentURL, error)
    }
}

extension DocumentBrowserDelegate {
    private func createDefaultDocumentName() -> String {
        let newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.documentNumberKey)
        return "Untitled \(newDocumentNumber)"
    }
    
    private func incrementDocumentNameCount() {
        let newDocumentNumber = UserDefaults.standard.integer(forKey: DocumentBrowserDelegate.documentNumberKey) + 1
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

