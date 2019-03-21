//
//  CurrencyConverterViewModelProtocol.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

protocol CurrencyConverterViewModelProtocol: AnyObject {
    func configure()
    func numberOfCurrency() -> Int
    func getCurrencyRate(forRow row: Int) -> Rates? //Fetching currency rates
    func move(startIndex: Int, destinationIndex: Int, newAmount: Double) //Tableview re-arrangement
    func updateAmountToConvert(_ newAmount: Double) //Update amount to convert
    func getCurrentBaseCurrency() -> String //Getter for base currency
}

protocol CurrencyConverterViewControllerProtocol: AnyObject {
    //Add rows to tableView
    func insertData(at indexPathArray: [IndexPath])
}
