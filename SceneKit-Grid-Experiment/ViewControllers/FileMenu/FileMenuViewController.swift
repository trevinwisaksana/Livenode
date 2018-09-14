//
//  FileMenuViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 19/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class FileMenuViewController<View: UIView>: UIViewController {
    
    // MARK: - Internal Properties
    
    lazy var mainView: View = {
        let mainView = View(frame: view.frame)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    override var navigationItem: UINavigationItem {
        return FileMenuNavigationItem()
    }
    
    private func setup() {
        view.addSubview(mainView)
        mainView.fillInSuperview()
    }
    
    // TESTING
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
