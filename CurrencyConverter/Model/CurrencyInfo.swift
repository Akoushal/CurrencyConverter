//
//  CurrencyInfo.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/20.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

//Struct for Currency Information from Mocked JSON. This struct is mapped to API response Model based on 'code'.
struct CurrencyInfo: Decodable {
    let symbol: String
    let currency: String
}

//Struct for Mocked JSON
struct CurrencyListInfo: Decodable {
    struct Response: Decodable {
        let rates: [CurrencyInfo]
    }
    let response: Response
}
