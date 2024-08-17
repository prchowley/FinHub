//
//  APIEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

protocol EndpointProvider {
    var baseURL: String { get }
    var apiKey: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndpointProvider {
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems + [URLQueryItem(name: "token", value: apiKey)]
        return components?.url
    }
}

enum FinnhubEndpoint: EndpointProvider {
    case stockSymbols
    case search(query: String)
    case companyProfile(symbol: String)
    case quote(symbol: String)
    
    var version: String { "/api/v1" }
    
    var baseURL: String {
        "https://finnhub.io"
    }
    
    var apiKey: String {
        return retrieveTokenFromKeychain(key: "finnhub") ?? "default_token_if_not_found"
    }
    
    var path: String {
        switch self {
        case .stockSymbols:
            return version + "/stock/symbol"
        case .search:
            return version + "/search"
        case .companyProfile:
            return version + "/stock/profile2"
        case .quote:
            return version + "/quote"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .stockSymbols:
            return [
                URLQueryItem(name: "exchange", value: "US"),
                URLQueryItem(name: "currency", value: "USD")
            ]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .companyProfile(let symbol):
            return [URLQueryItem(name: "symbol", value: symbol)]
        case .quote(let symbol):
            return [URLQueryItem(name: "symbol", value: symbol)]
        }
    }
}

enum AlphaVantageEndpoint: EndpointProvider {
    enum GraphFunction: String {
        case TIME_SERIES_INTRADAY
        case TIME_SERIES_DAILY
    }
    
    enum GraphInterval: String {
        case min5 = "5min"
    }
    
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
            return [
                URLQueryItem(name: "function", value: function.rawValue),
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "interval", value: interval.rawValue),
                URLQueryItem(name: "apikey", value: apiKey)
            ]
        }
    }
}
