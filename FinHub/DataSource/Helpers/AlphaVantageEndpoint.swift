//
//  AlphaVantageEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

enum AlphaVantageEndpoint: EndpointProvider {
    
    case graph(f: GraphFunction, symbol: String, interval: GraphInterval)
    
    var baseURL: String {
        "https://www.alphavantage.co/"
    }
    
    var apiKey: String {
        return retrieveTokenFromKeychain(key: "alpha") ?? "default_token_if_not_found"
    }
    
    var path: String {
        return "/query"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .graph(let function, let symbol, let interval):
            var qE = [
                URLQueryItem(name: "function", value: function.rawValue),
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "apikey", value: apiKey)
            ]
            if function == .TIME_SERIES_INTRADAY {
                qE.append(URLQueryItem(name: "interval", value: interval.rawValue))
            }
            return qE
        }
    }
}

