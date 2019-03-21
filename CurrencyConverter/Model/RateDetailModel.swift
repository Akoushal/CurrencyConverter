//
//  RateDetailModel.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

//Service Response Model
struct RateDetailModel: Codable {
    var base: String
    var date: String
    var rates: [String: Double]
}

extension RateDetailModel {
    func mapData(with currencyInfoList: Dictionary<String, CurrencyInfo>) -> [Rates] {
        return self.rates.map {(currencyCode: String, conversionRate: Double) -> Rates? in
            return Rates(currencyCode: currencyCode, conversionRate: conversionRate, currencyInfoList: currencyInfoList)}.compactMap { $0}
    }
}
