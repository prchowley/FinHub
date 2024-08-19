//
//  FinnhubEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

struct FinnhubEndpoint: EndpointProvider {
    enum EndpointType {
        case stockSymbols
        case search(query: String)
        case companyProfile(symbol: String)
        case quote(symbol: String)
    }
    
    private let endpointType: EndpointType
    private let keyService: KeyService
    
    init(
        endpointType: EndpointType,
        keyService: KeyService = KeyProvider.shared
    ) {
        self.endpointType = endpointType
        self.keyService = keyService
    }
    
    private var version: String { "/api/v1" }
    
    var baseURL: String {
        "https://finnhub.io"
    }
    
    var apiKey: String {
        keyService.get(for: .finnhub)
    }
    
    var path: String {
        switch endpointType {
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
        switch endpointType {
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
    
    func urlRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        guard let finalURL = urlComponents?.url else { return nil }
        return URLRequest(url: finalURL)
    }
}
