//
//  AlphaVantageEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Provides endpoint information for Alpha Vantage API requests.
struct AlphaVantageEndpoint: EndpointProvider {
    
    /// The function parameter for the API request.
    private let function: GraphFunction
    
    /// The stock symbol for the API request.
    private let symbol: String
    
    /// The interval parameter for the API request, used only for intraday functions.
    private let interval: GraphInterval
    
    /// The key service used to fetch the API key.
    private let keyService: KeyService

    /// Initializes a new instance of `AlphaVantageEndpoint`.
    /// - Parameters:
    ///   - function: The function parameter for the API request.
    ///   - symbol: The stock symbol for the API request.
    ///   - interval: The interval parameter for the API request.
    ///   - keyService: The key service to fetch the API key, default is `KeyProvider.shared`.
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

    /// The base URL for Alpha Vantage API.
    var baseURL: String {
        "https://www.alphavantage.co"
    }

    /// The path for the endpoint.
    var path: String {
        "/query"
    }

    /// The query items for the endpoint based on the function and symbol.
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

    /// Creates a URL request for the endpoint.
    /// - Returns: An optional `URLRequest` object if the URL is valid, otherwise `nil`.
    func urlRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        guard let finalURL = urlComponents?.url else { return nil }
        return URLRequest(url: finalURL)
    }
}

extension AlphaVantageEndpoint: APIKeyProvider {

    /// The API key for authentication.
    var apiKey: String {
        keyService.get(for: .alpha)
    }
}
