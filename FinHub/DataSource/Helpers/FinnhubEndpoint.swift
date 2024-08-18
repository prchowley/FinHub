//
//  FinnhubEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

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
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "token", value: apiKey)]
        switch self {
        case .stockSymbols:
            queryItems += [
                URLQueryItem(name: "exchange", value: "US"),
                URLQueryItem(name: "currency", value: "USD")
            ]
        case .search(let query):
            queryItems += [URLQueryItem(name: "q", value: query)]
        case .companyProfile(let symbol):
            queryItems += [URLQueryItem(name: "symbol", value: symbol)]
        case .quote(let symbol):
            queryItems += [URLQueryItem(name: "symbol", value: symbol)]
        }
        return queryItems
    }
}
