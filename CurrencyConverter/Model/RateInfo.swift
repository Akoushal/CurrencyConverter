//
//  RateInfo.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/20.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import UIKit

//Rate Object Model
struct RateInfo: Equatable {
    let currencyCode: String
    let currencyFullname: String
    let flagImage: UIImage
}

extension RateInfo {
    //Init - failable
    init?(currencyCode: String, currencyInfoDict: Dictionary<String, CurrencyInfo>) {
        guard let currencyInfo = currencyInfoDict[currencyCode], let flagImage = UIImage(named: currencyCode.lowercased()) else { return nil}
        self.currencyCode = currencyCode
        self.currencyFullname = currencyInfo.currency
        self.flagImage = flagImage
    }
}
