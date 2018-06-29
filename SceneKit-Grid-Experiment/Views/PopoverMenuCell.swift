//
//  PopoverMenuCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 16/05/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol PopoverMenuDelegate: class {
    func delete()
    func move()
    func copy()
    func paste()
}

final class PopoverMenuCell: UICollectionViewCell {
    
    //---- Properties ----//
    
    weak var delegate: PopoverMenuDelegate?
    
    //---- IBOutlets ----//
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    //---- IBActions ----//
    
    @IBAction func didPressButton(_ sender: UIButton) {
        
        // TODO: Every button press should dismiss the popover
        switch sender.titleLabel?.text {
        case "Delete":
            delegate?.delete()
        case "Move":
            delegate?.move()
        case "Copy":
            delegate?.copy()
        case "Paste":
            delegate?.paste()
        default:
            break
        }
        
    }
    
}
