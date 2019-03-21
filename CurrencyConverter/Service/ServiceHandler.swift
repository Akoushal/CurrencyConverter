//
//  Service.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/20.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

protocol RatesChangeProtocol: AnyObject {
    //Delegate to manage rate change
    func currencyRatesDidChange(newCurrencyRates: [Rates])
}

class ServiceHandler {
    // Protocol conforming to rates and currency information
    private let currencyServiceProvider: CurrencyServiceProviderProtocol
    
    // Mocked JSON Data
    private let currencyInfoDict: Dictionary<String, CurrencyInfo>
    
    // Polling task used by the manager to fetch CurrencyRates periodically
    private var pollTask: AsyncPollingTask<RateDetailModel>?
    
    // List of listeners that will be notified when `rates` change
    weak var delegate: RatesChangeProtocol?
    
    var baseCurrency: String {
        didSet {
            self.pollTask = nil
            let requestFactory = RequestFactory(getRequest: { [unowned self] in
                return self.currencyServiceProvider.getCurrencyRates(baseCurrency: self.baseCurrency)
                }
            )
            self.configurePolling(withRequestFactory: requestFactory)
        }
    }
    
    init?(baseCurrency: String, currencyServiceProvider: CurrencyServiceProviderProtocol? = nil) {
        self.currencyServiceProvider = currencyServiceProvider ?? CurrencyServiceProvider()
        guard let fetchedCurrencyInfoDict = try? self.currencyServiceProvider.getCurrencyListInfo() else { return nil}
        self.baseCurrency = baseCurrency

        self.currencyInfoDict = fetchedCurrencyInfoDict
    }
    
    // Function that create and activate the polling task
    func startPolling() {
        let requestFactory = RequestFactory(getRequest: { [unowned self] in
            return self.currencyServiceProvider.getCurrencyRates(baseCurrency: self.baseCurrency)
            }
        )
        configurePolling(withRequestFactory: requestFactory)
    }
    
    //Configure the manager's `pollTask` then start the polling timer
    private func configurePolling(withRequestFactory requestFactory: RequestFactory<RateDetailModel>) {
        self.pollTask = AsyncPollingTask(requestFactory: requestFactory, completion: { [unowned self] in
            if let currentCurrencyRate = self.getCurrentCurrencyRate() {
                self.delegate?.currencyRatesDidChange(newCurrencyRates:[currentCurrencyRate] + $0.mapData(with: self.currencyInfoDict))
            }
            self.delegate?.currencyRatesDidChange(newCurrencyRates:$0.mapData(with: self.currencyInfoDict))
            }, interval: 1)
        self.pollTask?.start()
    }
    
    private func getCurrentCurrencyRate() -> Rates? {
        return Rates(currencyCode: baseCurrency, conversionRate: 1, currencyInfoList: currencyInfoDict)
    }
}

