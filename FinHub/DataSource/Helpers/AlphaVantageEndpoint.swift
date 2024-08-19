//
//  AlphaVantageEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

struct AlphaVantageEndpoint: EndpointProvider {
    
    private let function: GraphFunction
    private let symbol: String
    private let interval: GraphInterval
    private let keyService: KeyService

    init(
        function: GraphFunction,
        symbol: String, 
        interval: GraphInterval,
        keyService: KeyService = KeyProvider.shared
    ) {
        self.function = function
        self.symbol = symbol
        self.interval = interval
        self.keyService = keyService
    }

    var baseURL: String {
        "https://www.alphavantage.co"
    }

    var apiKey: String {
        keyService.get(for: .alpha)
    }

    var path: String {
        "/query"
    }

    var queryItems: [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: "function", value: function.rawValue),
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        if function == .TIME_SERIES_INTRADAY {
            queryItems.append(URLQueryItem(name: "interval", value: interval.rawValue))
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
