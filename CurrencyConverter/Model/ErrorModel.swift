//
//  ErrorModel.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/20.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

struct ErrorModel: Decodable {
    let Code: String?
    let Message: String?
}
