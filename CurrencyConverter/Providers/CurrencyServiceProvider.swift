//
//  CurrencyServiceProvider.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/14.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Alamofire
import Promise

enum CurrencyConverterError: Error {
    case noResponse
    case requestUrlError
}

protocol CurrencyServiceProviderProtocol {
    //Endpoint for fetching rates as per base currency
    func getCurrencyRates(baseCurrency: String) -> Promise<RateDetailModel>
    
    //Fetch data from mocked JSON to get the currencies information such as name and code. Code is mapped to 'code' from API response and displayed on the UI
    func getCurrencyListInfo() throws -> Dictionary<String, CurrencyInfo>
}

class CurrencyServiceProvider: CurrencyServiceProviderProtocol {
    let queue = DispatchQueue(label: "currency_manager_queue", qos: .background)
    
    func getCurrencyRates(baseCurrency: String) -> Promise<RateDetailModel> {
        guard let request = try? Router.getCurrencyRates(baseCurrencyCode: baseCurrency).asURLRequest() else {
            return Promise(error: CurrencyConverterError.requestUrlError)
        }
        
        return Promise<RateDetailModel> { fulfill, reject in
            Alamofire.request(request).validate().responseJSON(queue: self.queue) { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            throw CurrencyConverterError.noResponse
                        }
                        let currencyRates = try JSONDecoder().decode(RateDetailModel.self, from: data)
                        fulfill(currencyRates)
                    }
                    catch let error {
                        reject(error)
                        print("getCurrencyRates - Error - \(error)")
                    }
                case .failure(let error):
                    reject(error)
                    print("getCurrencyRates - Error - \(error)")
                }
            }
        }
    }
    
    //To get information such as 'name' for currency code and Map
    func getCurrencyListInfo() throws -> Dictionary<String, CurrencyInfo> {
        guard let path = Bundle.main.path(forResource: "ECBCurrencyList", ofType: "json") else { throw CurrencyConverterError.noResponse }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let currencyInfoList = try JSONDecoder().decode(CurrencyListInfo.self, from: data)
        let currencyTupleList = currencyInfoList.response.rates.map({ currency in
            (currency.symbol, currency)
        })
        return Dictionary(currencyTupleList, uniquingKeysWith: { first, _ in first })
    }
}
