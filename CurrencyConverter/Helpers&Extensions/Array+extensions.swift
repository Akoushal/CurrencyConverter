//
//  Array+extensions.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/12.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

extension Array {
    /** Safe subscript -> return nil if out of range */
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
