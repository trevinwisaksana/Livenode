//
//  UICollectionView+Utility.swift
//  Scene
//
//  Created by Trevin Wisaksana on 21/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import UIKit

protocol CellIdentifiable: class {
    static var cellIdentifier: String { get }
}

protocol ReusableViewIdentifiable: class {
    static var identifier: String { get }
}

extension CellIdentifiable where Self: UICollectionViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }

}

extension ReusableViewIdentifiable where Self: UICollectionReusableView {
    
    static var identifer: String {
        return String(describing: self)
    }
    
}

extension UICollectionViewCell: CellIdentifiable { }

extension UICollectionReusableView: ReusableViewIdentifiable {
    
    static var identifier: String {
        return self.identifer
    }
    
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifer, for: indexPath) as? T else {
            fatalError("Error dequeuing reusable view for identifier \(T.identifer)")
        }
        
        return supplementaryView
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.cellIdentifier)
    }
    
}
