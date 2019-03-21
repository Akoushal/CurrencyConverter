//
//  UITableViewCell+extensions.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/12.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var uniqueIdentifier: String {
        return String(describing: self)
    }
}

