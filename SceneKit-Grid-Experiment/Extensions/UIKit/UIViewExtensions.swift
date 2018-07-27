//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - Fill in Superview

public extension UIView {
    /// Layouts the current view to fit it's superview.
    ///
    /// - Parameters:
    ///   - insets: The inset for fitting the superview.
    ///   - isActive: A boolean on whether the constraint is active or not.
    /// - Returns: The added constraints.
    @discardableResult
    public func fillInSuperview(insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return [NSLayoutConstraint]()
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.trailing))

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
}

// MARK: - Anchors

public extension UIView {
    public convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }
    
    public var compatibleTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    public var compatibleBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
}
