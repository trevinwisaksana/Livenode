//
//  ObjectCatalogPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public class ObjectCatalogDataSource: NSObject {
    
}

public class ObjectCatalogPresentableView: UIView {
    
    lazy var dataSource: ObjectCatalogDataSource = {
        return ObjectCatalogDataSource()
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = ObjectCatalogView(delegate: self, dataSource: self)
        addSubview(view)
        view.fillInSuperview()
        backgroundColor = .white
    }
    
}

// MARK: - ObjectCatalogViewDelegate

extension ObjectCatalogPresentableView: ObjectCatalogViewDelegate {
    public func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
}

// MARK: - ObjectCatalogViewDataSource

extension ObjectCatalogPresentableView: ObjectCatalogViewDataSource {
    public func viewModel(InObjectCatalogView sceneAcobjectCatalogViewtionsMenuView: ObjectCatalogView) -> ObjectCatalogViewModel {
        return ObjectCatalog()
    }
}
