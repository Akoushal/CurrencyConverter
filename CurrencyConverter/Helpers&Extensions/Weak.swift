//
//  Weak.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/16.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

//Wrapper for weak reference of object
class Weak<T: AnyObject> {
    weak var value: T?
    init (value: T) {
        self.value = value
    }
}
