//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Koushal, KumarAjitesh on 2019/03/21.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import XCTest
import Promise
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    // For checking correct initialization of RateInfo, Rates and RateDetailModel
    // Used in test_initRateInfoModel(), test_initRatesModel(), test_mapMockedJSONData()
    let currencyInfoDict = [ "JPY": CurrencyInfo(symbol: "JPY", currency: "Japanese Yen") , "USD": CurrencyInfo(symbol: "USD", currency: "US Dollar") , "GBP": CurrencyInfo(symbol: "GBP", currency: "Great Bitain Pound") , "AUD": CurrencyInfo(symbol: "AUD", currency: "Australian Dollar")]
    
    // Used in test_serializeCurrencyInfo()
    let currencyInfoMockedJSON = ["symbol":"AUD", "currency":"Australian Dollar"]
    
    // Used in test_serializeCurrencyListInfo()
    let currencyListInfoMockedJSON = ["response":["rates":[["symbol":"USD","currency":"United States Dollar"],["symbol":"JPY","currency":"Japanese Yen"]]]]
    
    // Used in test_serializeRateDetailModel()
    let rateListMockedJSON: [String: Any] = ["base":"EUR", "date":"2019-03-21", "rates":["NZD":1.78, "PLN":4.34]]
    
    // Used in test_startPollingTask()
    var testPoll: AsyncPollingTask<Bool>?
    
    /*
     // Test: For check initialization of CurrencyServiceProvider and ServiceHandler classes. These classes control and conform to Polling and delegates
     */
    func test_checkInitCurrencyServiceProvider() {
        class MockProvider: CurrencyServiceProviderProtocol {
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: String) -> Promise<RateDetailModel> {
                XCTFail("getCurrencyRates should not be called")
                return Promise(error: CurrencyConverterError.noResponse)
            }
            
            func getCurrencyListInfo() throws -> Dictionary<String, CurrencyInfo> {
                XCTAssert(true)
                expectation?.fulfill()
                return [:]
            }
        }
        
        let expectation = XCTestExpectation(description: "getCurrencyListInfo method call")
        let mockProvider = MockProvider()
        mockProvider.expectation = expectation
        
        _ = ServiceHandler(baseCurrency: "EUR", currencyServiceProvider: mockProvider)
        wait(for: [expectation], timeout: 2.0)
    }
    
    /*
     // Test: For serializing mocked JSON object into CurrencyInfo Model
     */
    func test_serializeCurrencyInfo() {
        guard let data = try? JSONSerialization.data(withJSONObject: currencyInfoMockedJSON, options: .prettyPrinted), let currencyInfo = try? JSONDecoder().decode(CurrencyInfo.self, from: data) else {
            XCTFail()
            return
        }
        
        XCTAssert(currencyInfo.symbol == "AUD")
        XCTAssert(currencyInfo.currency == "Australian Dollar")
    }
    
    /*
     // Test: For serializing mocked JSON object into CurrencyListInfo Model
     */
    func test_serializeCurrencyListInfo() {
        guard let data = try? JSONSerialization.data(withJSONObject: currencyListInfoMockedJSON, options: .prettyPrinted), let currencyListInfo = try? JSONDecoder().decode(CurrencyListInfo.self, from: data) else {
            XCTFail()
            return
        }
        
        XCTAssert(currencyListInfo.response.rates.count == 2)
        XCTAssert(currencyListInfo.response.rates.first?.symbol == "USD")
    }
    
    /*
     // Test: For serializing mocked JSON object into RateDetailModel
     */
    func test_serializeRateDetailModel()
    {
        guard let data = try? JSONSerialization.data(withJSONObject: rateListMockedJSON, options: .prettyPrinted), let rateModel = try? JSONDecoder().decode(RateDetailModel.self, from: data) else {
            XCTFail()
            return
        }
        
        XCTAssert(rateModel.base == "EUR")
        XCTAssert(rateModel.rates.count == 2)
    }
    
    /*
     // Test: For checking whether RateInfoModel is properly initialized with correct parameters i.e. currencyCode, currencyFullname and flagImage
     */
    func test_initRateInfoModel() {
        let rateInfo = RateInfo(currencyCode: "AUD", currencyInfoDict: currencyInfoDict)
        XCTAssert(rateInfo?.currencyCode == "AUD")
        XCTAssert(rateInfo?.currencyFullname == "Australian Dollar")
        
        let test_image = UIImage(named: "aud", in: Bundle(for: CurrencyConverterTests.self), compatibleWith: nil)
        XCTAssert(rateInfo?.flagImage.pngData() == test_image?.pngData())
    }
    
    /*
     //Test: For checking whether RatesModel is properly initialized with correct parameters
     */
    func test_initRatesModel() {
        let rateInfo = RateInfo(currencyCode: "AUD", currencyInfoDict: currencyInfoDict)
        let rates = Rates(currencyCode: "AUD", conversionRate: 1.0, currencyInfoList: currencyInfoDict)
        XCTAssert(rates?.currencyInfo == rateInfo)
    }
    
    /*
     // Test: For correct mapping of mocked JSON data with RateDetailModel so as to get CurrencyName and flagImage
     */
    func test_mapMockedJSONData() {
        let rates = [ "JPY": 120.0, "USD": 1.09, "GBP": 0.9, "AUD": 1.60, "fail_case": 0]
        let rateModel = RateDetailModel(base: "EUR", date: "date", rates: rates)
        let rateList = rateModel.mapData(with: currencyInfoDict)
        
        XCTAssert(rateList.count == 4)
        
        let jyp_currencyInfo = rateList.first(where: {
            $0.currencyInfo.currencyCode == "JPY"
        })
        XCTAssert(jyp_currencyInfo?.conversionRate == 120.0)
        
        let test_image = UIImage(named: "jpy", in: Bundle(for: CurrencyConverterTests.self), compatibleWith: nil)
        XCTAssert(jyp_currencyInfo?.currencyInfo.flagImage.pngData() == test_image?.pngData())
    }
    
    /*
     // Test: When ServiceHandler's startPolling is called, the task should be created and getCurrencyRates method should be called
     */
    func test_startPolling() {
        class MockProvider: CurrencyServiceProviderProtocol {
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: String) -> Promise<RateDetailModel> {
                XCTAssert(baseCurrency == "EUR")
                expectation?.fulfill()
                let rateModel = RateDetailModel(base: "base", date: "date", rates: [:])
                return Promise(value: rateModel)
            }
            
            func getCurrencyListInfo() throws -> Dictionary<String, CurrencyInfo> {
                return [:]
            }
        }
        
        let expectation = XCTestExpectation(description: "polling")
        let mockProvider = MockProvider()
        mockProvider.expectation = expectation
        
        let serviceHandler = ServiceHandler(baseCurrency: "EUR", currencyServiceProvider: mockProvider)
        serviceHandler?.startPolling()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    /*
     // Test: When baseCurrency is changed, new polling task is created for the currency
     */
    func test_baseCurrencyChanged() {
        class MockProvider: CurrencyServiceProviderProtocol {
            var currentBaseCurrency: String = "EUR"
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: String) -> Promise<RateDetailModel> {
                XCTAssert(baseCurrency == currentBaseCurrency)
                expectation?.fulfill()
                let rateModel = RateDetailModel(base: "base", date: "date", rates: [:])
                return Promise(value: rateModel)
            }
            
            func getCurrencyListInfo() throws -> Dictionary<String, CurrencyInfo> {
                return [:]
            }
        }
        
        // Start Polling with BaseCurrency = EUR
        let expectation_1 = XCTestExpectation(description: "polling")
        let mockProvider = MockProvider()
        mockProvider.expectation = expectation_1
        
        let serviceHandler = ServiceHandler(baseCurrency: "EUR", currencyServiceProvider: mockProvider)
        serviceHandler?.startPolling()
        wait(for: [expectation_1], timeout: 2.0)
        
        //BaseCurrency changed to JPY -> expects getCurrencyRates to be called with JPY
        let expectation_2 = XCTestExpectation(description: "Poll task recreated with new baseCurrency")
        mockProvider.expectation = expectation_2
        serviceHandler?.baseCurrency = "JPY"
        mockProvider.currentBaseCurrency = "JPY"
        wait(for: [expectation_2], timeout: 2.0)
    }
    
    /*
     // Test: For checking at each Timer tick, correct response is returned
     */
    func test_startPollingTask() {
        var count = 0
        let testRequestFactory = RequestFactory(getRequest: {
            return Promise<Bool> { fulfill, reject in
                fulfill(true)
            }
        })
        
        let expectation = XCTestExpectation(description: "Get 3 ticks of polling")
        testPoll = AsyncPollingTask(requestFactory: testRequestFactory, completion: { response in
            XCTAssert(response == true)
            guard count < 3 else {
                self.testPoll = nil
                expectation.fulfill()
                return
            }
            count += 1
        }, interval: 1)
        
        testPoll?.start()
        wait(for: [expectation], timeout: 4.0)
        XCTAssert(count == 3)
    }
}

