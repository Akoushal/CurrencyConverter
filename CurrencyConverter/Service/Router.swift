//
//  Router.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/16.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import Alamofire

//Service Router
enum Router: URLRequestConvertible {
    case getCurrencyRates(baseCurrencyCode: String)
    
    var method: HTTPMethod {
        switch self {
            case .getCurrencyRates: return .get
        }
    }
    
    var path: String {
        switch self {
            case .getCurrencyRates: return Configuration.baseURL
        }
    }
    
    //URL request
    func asURLRequest() throws -> URLRequest {
        let baseURL = try path.asURL()
        
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getCurrencyRates(let baseCurrencyCode):
            let queryItem = URLQueryItem(name: "base", value: baseCurrencyCode)
            var urlComp = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            urlComp?.queryItems = [queryItem]
            urlRequest.url = urlComp?.url
        }
        
        return urlRequest
    }
}
