//
//  Codable.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/08/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

struct CodableWrapper<Wrapped>: Codable where Wrapped: NSCoding {
    var wrapped: Wrapped
    
    init(_ wrapped: Wrapped) { self.wrapped = wrapped }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "failed to unarchive an object")
        }
        guard let wrapped = object as? Wrapped else {
            throw DecodingError.typeMismatch(Wrapped.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "unarchived object type was \(type(of: object))"))
        }
        self.wrapped = wrapped
    }
    
    func encode(to encoder: Encoder) throws {
        let data = NSKeyedArchiver.archivedData(withRootObject: wrapped)
        var container =  encoder.singleValueContainer()
        try container.encode(data)
    }
}
