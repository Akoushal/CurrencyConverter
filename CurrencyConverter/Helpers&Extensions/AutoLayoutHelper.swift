//
//  AutoLayoutHelper.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/06.
//  Copyright © 2019 Unifa. All rights reserved.
//

import UIKit

public extension Array where Element: NSLayoutConstraint {
    /**
     Activates all layout constraints inside the array.
     */
    @discardableResult func activate() -> Array {
        forEach { $0.isActive = true }
        return self
    }
}

public extension UIView {
    /**
     Enum that defines the index of layout constraints returned
     by edgesAnchor functions.
     */
    enum EdgeAnchorIndex: Int {
        case left = 0, right, top, bottom
    }
    
    /**
     Creates layout constrains for snapping the view to the provided superview
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func edgesAnchorEqualTo(destinationView: UIView) -> [NSLayoutConstraint] {
        return [leftAnchor.constraint(equalTo: destinationView.leftAnchor),
                rightAnchor.constraint(equalTo: destinationView.rightAnchor),
                topAnchor.constraint(equalTo: destinationView.topAnchor),
                bottomAnchor.constraint(equalTo: destinationView.bottomAnchor)]
    }
    
    /**
     Creates layout constrains for all 4 edges of a view,
     and makes it match to the provided view.
     
     - return: An array with 4 constraints. The indexes are
     defined by the `EdgeAnchorIndex` enum.
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func edgesAnchorEqualTo(destinationView: UIView, insets: UIEdgeInsets) -> Array<NSLayoutConstraint> {
        return [leftAnchor.constraint(equalTo: destinationView.leftAnchor, constant: insets.left),
                rightAnchor.constraint(equalTo: destinationView.rightAnchor, constant: -insets.right),
                topAnchor.constraint(equalTo: destinationView.topAnchor, constant: insets.top),
                bottomAnchor.constraint(equalTo: destinationView.bottomAnchor, constant: -insets.bottom)]
    }
    
    /**
     Creates layout constrains for all 4 edges of a view,
     and makes it match to the provided layout guide.
     
     - return: An array with 4 constraints. The indexes are
     defined by the `EdgeAnchorIndex` enum.
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func edgesAnchorEqualTo(layoutGuide: UILayoutGuide, insets: UIEdgeInsets? = nil) -> Array<NSLayoutConstraint> {
        return [leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets?.left ?? 0),
                rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -(insets?.right ?? 0)),
                topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets?.top ?? 0),
                bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -(insets?.bottom ?? 0))]
    }
    
    /**
     Snap the edge of the receiver to the view containing it
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func edgesAnchorEqualTo(destinationView view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if let top = top {
            constraints.append(self.topAnchor.constraint(equalTo: view.topAnchor, constant: top))
        }
        if let bottom = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom))
        }
        if let left = left {
            constraints.append(self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left))
        }
        if let right = right {
            constraints.append(self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -right))
        }
        return constraints
    }
    
    /**
     Snap the edge of the receiver to the view containing it
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func edgesAnchorEqualTo(destinationView view: UIView, verticalPadding: CGFloat? = nil, horizontalPadding: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if let verticalPadding = verticalPadding {
            constraints.append(self.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalPadding))
            constraints.append(self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalPadding))
        }
        if let horizontalPadding = horizontalPadding {
            constraints.append(self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalPadding))
            constraints.append(self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalPadding))
        }
        return constraints
    }
    
    /**
     Size the receiver with given width and/or height
     
     - Important: Constraints are not activated. You need
     to activate them for them to take effect.
     */
    func sizing(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if let width = width {
            constraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        return constraints
    }
    
    /**
     Returns the safe area bottom anchor.
     If not available, returns the bottom anchor.
     */
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    /**
     Returns the safe area top anchor.
     If not available, returns the top anchor.
     */
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
}

public extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    /**
     Assign the priority to the constraint and return the caller
     */
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        
        self.priority = UILayoutPriority(priority)
        return self
    }
    
    /**
     Set priority to 999 to avoid auto layout conflict
     */
    func withPriorityFix() -> NSLayoutConstraint {
        return self.withPriority(999)
    }
    
}
