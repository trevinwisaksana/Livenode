//
//  ObjectAttributeCell.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 29/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol ObjectAttributeDelegate: class {
    func changeColor()
}

final class ObjectAttributeCell: UICollectionViewCell {
    
    weak var delegate: ObjectAttributeDelegate?
    
    @IBAction func didTapChangeColorButton(sender: UIButton) {
        delegate?.changeColor()
    }
    
}
