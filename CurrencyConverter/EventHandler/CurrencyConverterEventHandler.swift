//
//  CurrencyConverterEventHandler.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import UIKit

class CurrencyConverterEventHandler {
    struct State {
        var currentBaseCurrency: String = Configuration.defaultBaseCurrency
        var currencyRates: [Rates] = []
        var amountToConvert: Double = 1 //Initial Value
    }
    
    private weak var view: CurrencyConverterViewControllerProtocol?
    private var serviceHandler = ServiceHandler(baseCurrency: Configuration.defaultBaseCurrency)
    private var state: State = State()
    
    var delegates: [Weak<RateCell>] = []
    
    init(view: CurrencyConverterViewControllerProtocol?) {
        self.view = view
    }
}

extension CurrencyConverterEventHandler: CurrencyConverterViewModelProtocol {
    // Configure the eventHandler to receive currency rates data
    func configure() {
        serviceHandler?.delegate = self
        serviceHandler?.startPolling()
    }
    
    //number of currencyRates
    func numberOfCurrency() -> Int {
        return state.currencyRates.count
    }
    
    //Fetch currency rates
    func getCurrencyRate(forRow row: Int) -> Rates? {
        return state.currencyRates[safe: row]
    }
    
    //Tableview cells rearrangement
    func move(startIndex: Int, destinationIndex: Int, newAmount: Double) {
        guard let movedObject = state.currencyRates[safe: startIndex] else { return}
        
        state.currencyRates.remove(at: startIndex)
        state.currencyRates.insert(movedObject, at: destinationIndex)
        
        let newCurrentCurrency = movedObject.currencyInfo.currencyCode
        serviceHandler?.baseCurrency = newCurrentCurrency
        state.currentBaseCurrency = newCurrentCurrency
        
        updateAmountToConvert(newAmount)
        
        delegates.forEach({
            $0.value?.updateCurrentCurrency(newBaseCurrency: newCurrentCurrency)
        })
    }
    
    //Amount to be converted
    func updateAmountToConvert(_ newAmount: Double) {
        state.amountToConvert = newAmount
        delegates.forEach({
            $0.value?.updateRateAndAmount(from: state.currencyRates, currentBaseCurrency: state.currentBaseCurrency, amountToConvert: state.amountToConvert)
        })
    }
    
    //Getter for currentBaseCurrency
    func getCurrentBaseCurrency() -> String {
        return state.currentBaseCurrency
    }
}

//Mark: - Polling Succeeds callback
extension CurrencyConverterEventHandler: RatesChangeProtocol {
    func currencyRatesDidChange(newCurrencyRates: [Rates]) {
        var indexToInsert: [IndexPath] = []
        newCurrencyRates.forEach({ currencyRate in
            if let indexToUpdate = self.state.currencyRates.firstIndex(where: {
                $0.currencyInfo.currencyCode == currencyRate.currencyInfo.currencyCode
            }) {
                self.state.currencyRates[indexToUpdate] = currencyRate
            } else {
                self.state.currencyRates.append(currencyRate)
                let indexPath = IndexPath(row: self.state.currencyRates.count - 1, section: 0)
                indexToInsert.append(indexPath)
            }
        })
        self.view?.insertData(at: indexToInsert)
        
        // Update cells
        delegates.forEach({
            $0.value?.updateRateAndAmount(from: newCurrencyRates, currentBaseCurrency: state.currentBaseCurrency, amountToConvert: state.amountToConvert)
        })
    }
}
