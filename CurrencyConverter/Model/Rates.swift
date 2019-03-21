//
//  Rates.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/20.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

//For getting flag image for currency
struct Rates: Equatable {
    let conversionRate: Double
    let currencyInfo: RateInfo
}

extension Rates {
    //Init - failable
    init?(currencyCode: String, conversionRate: Double, currencyInfoList: Dictionary<String, CurrencyInfo>) {
        guard let currencyInfo = RateInfo(currencyCode: currencyCode, currencyInfoDict: currencyInfoList) else { return nil}
        self.conversionRate = conversionRate
        self.currencyInfo = currencyInfo
    }
}
