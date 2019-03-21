//
//  UINavigationBarExtensions.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    /**
     Sets the shadow color for the application's navigation bar.
     
     - Note: This is done through `UINavigationBar`'s appearance
     proxy.
     */
    static func setGlobalShadowColor(color: UIColor) {
        setShadowColor(color: color, bar: UINavigationBar.appearance())
    }
    
    /**
     Sets the navigation bar's shadow color.
     */
    func setShadowColor(color: UIColor) {
        UINavigationBar.setShadowColor(color: color, bar: self)
    }
    
    // MARK: Private methods
    
    static private func setShadowColor(color: UIColor, bar: UINavigationBar) {
        let shadowImage = UINavigationBar.barImage(from: color)
        bar.shadowImage = shadowImage
    }
    static private func barImage(from color: UIColor) -> UIImage? {
        let shadowSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(shadowSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: shadowSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
