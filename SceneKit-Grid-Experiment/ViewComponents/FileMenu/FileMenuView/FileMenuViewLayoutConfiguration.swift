//
//  FileMenuViewLayoutConfiguration.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum FileMenuViewLayoutConfiguration {
    case small
    case medium
    case large(CGFloat)

    static let mediumRange: Range<CGFloat> = (375.0 ..< 415.0)
    static let portraitModeScreenWidth = CGFloat(768)

    init(width: CGFloat) {
        switch width {
        case let width where width > FileMenuViewLayoutConfiguration.mediumRange.upperBound:
            self = .large(width)
        case let width where width < FileMenuViewLayoutConfiguration.mediumRange.lowerBound:
            self = .small
        default:
            self = .medium
        }
    }

    var interimSpacing: CGFloat {
        switch self {
        case .large:
            return 0
        default:
            return 0
        }
    }

    var sideMargins: CGFloat {
        switch self {
        case .large:
            return 20
        default:
            return 16
        }
    }

    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return UIEdgeInsets(top: 16, left: sideMargins, bottom: 0, right: sideMargins)
        default:
            return UIEdgeInsets(top: 8, left: sideMargins, bottom: 0, right: sideMargins)
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .large:
            return 30
        default:
            return 16
        }
    }

    var itemsPerRow: CGFloat {
        switch self {
        case let .large(width):
            if width > FileMenuViewLayoutConfiguration.portraitModeScreenWidth {
                return 6
            } else {
                return 5
            }
        case .medium:
            return 4
        case .small:
            return 3
        }
    }

    var itemHeight: CGFloat {
        switch self {
        case .large:
            return 80
        default:
            return 60
        }
    }
}
