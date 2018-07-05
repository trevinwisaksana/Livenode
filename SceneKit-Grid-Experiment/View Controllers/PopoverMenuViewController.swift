//
//  PopoverMenuViewController.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 15/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol MenuActionDelegate: class {
    func delete()
    func move()
    func copy()
    func paste()
}

final class PopoverMenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = PopoverMenuViewModel()
    weak var menuAction: MenuActionDelegate?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 290, height: 45)
    }
    
}

extension PopoverMenuViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopoverMenuCell", for: indexPath) as! PopoverMenuCell
        cell.delegate = self
        
        switch row {
        case 0:
            cell.buttonOutlet.setTitle(Action.move.capitalized, for: .normal)
        case 1:
            cell.buttonOutlet.setTitle(Action.delete.capitalized, for: .normal)
        case 2:
            cell.buttonOutlet.setTitle(Action.copy.capitalized, for: .normal)
        case 3:
            cell.buttonOutlet.setTitle(Action.paste.capitalized, for: .normal)
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension PopoverMenuViewController: PopoverMenuDelegate {
    
    func move() {
        viewModel.makeNodeMovable()
        menuAction?.move()
        
        dismiss(animated: true, completion: nil)
    }
    
    func delete() {
        viewModel.removeNode()
        
        dismiss(animated: true, completion: nil)
    }
    
    func paste() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func copy() {
        
        dismiss(animated: true, completion: nil)
    }
    
}
