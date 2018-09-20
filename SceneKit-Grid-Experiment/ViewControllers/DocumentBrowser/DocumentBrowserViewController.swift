//
//  DocumentBrowserViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class DocumentBrowserViewController: UIDocumentBrowserViewController {
    
    // MARK: - Internal Properties
    
    
    // MARK: - VC Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        browserUserInterfaceStyle = .white
        
        
    }
    
    // MARK: - Testing
    
    func countFile() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("Count: \(fileURLs.count)")
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func createFile() {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("Test")
            let image = #imageLiteral(resourceName: "box_wireframe")
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                try imageData.write(to: fileURL)
            }
        } catch {
            print(error)
        }
    }
    
}

extension DocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    private func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    }
    
    private func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
    }
    
    private func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
    }
    
    private func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    }
}
