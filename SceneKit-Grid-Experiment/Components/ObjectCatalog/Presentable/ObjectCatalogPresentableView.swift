//
//  ObjectCatalogPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 26/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public class ObjectCatalogDataSource: NSObject {
    let objectModels: [ObjectCatalogModel] = ObjectCatalogModelFactory.create()
}

public protocol ObjectCatalogPresentableViewDelegate: class {
    func objectCatalogPresentableView(_ objectCatalogPresentableView: ObjectCatalogPresentableView, didSelectNodeModel model: NodeModel)
}

public class ObjectCatalogPresentableView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var dataSource: ObjectCatalogDataSource = {
        return ObjectCatalogDataSource()
    }()
    
    weak var delegate: ObjectCatalogPresentableViewDelegate?
    
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
    public func objectCatalogView(_ objectCatalogView: ObjectCatalogView, didSelectNodeModel model: NodeModel) {
        delegate?.objectCatalogPresentableView(self, didSelectNodeModel: model)
    }
}

// MARK: - ObjectCatalogViewDataSource

extension ObjectCatalogPresentableView: ObjectCatalogViewDataSource {
    public func numberOfItems(InObjectCatalogView inObjectCatalogView: ObjectCatalogView) -> Int {
        return dataSource.objectModels.count
    }
    
    public func objectCatalogView(_ objectCatalogView: ObjectCatalogView, modelAtIndex index: Int) -> ObjectCatalogViewModel {
        return dataSource.objectModels[index]
    }
}
