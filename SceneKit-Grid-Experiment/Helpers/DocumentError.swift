//
//  DocumentError.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 20/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

enum DocumentError: Error {
    case unrecognizedContent
    case corruptDocument
    case archivingFailure
    
    var localizedDescription: String {
        switch self {
        case .unrecognizedContent:
            return NSLocalizedString("File is an unrecognised format", comment: "")
        case .corruptDocument:
            return NSLocalizedString("File could not be read", comment: "")
        case .archivingFailure:
            return NSLocalizedString("File could not be saved", comment: "")
        }
    }
}
