//
//  FinnhubEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Provides endpoint information for Finnhub API requests.
struct FinnhubEndpoint: EndpointProvider {
    
    /// Types of endpoints available in Finnhub API.
    enum EndpointType {
        /// Endpoint for fetching stock symbols.
        case stockSymbols
        
        /// Endpoint for searching with a query.
        case search(query: String)
        
        /// Endpoint for fetching company profile with a given symbol.
        case companyProfile(symbol: String)
        
        /// Endpoint for fetching quote data for a given symbol.
        case quote(symbol: String)
    }
    
    /// The type of endpoint being used.
    private let endpointType: EndpointType
    
    /// The key service used to fetch the API key.
    private let keyService: KeyService
    
    /// Initializes a new instance of `FinnhubEndpoint`.
    /// - Parameters:
    ///   - endpointType: The type of endpoint.
    ///   - keyService: The key service to fetch the API key, default is `KeyProvider.shared`.
    init(
        endpointType: EndpointType,
        keyService: KeyService = KeyProvider.shared
    ) {
        self.endpointType = endpointType
        self.keyService = keyService
    }
    
    /// The API version.
    private var version: String { "/api/v1" }
    
    /// The base URL for Finnhub API.
    var baseURL: String {
        "https://finnhub.io"
    }
    
    /// The API key for authentication.
    var apiKey: String {
        keyService.get(for: .finnhub)
    }
    
    /// The path for the endpoint based on the endpoint type.
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
    
    /// The query items for the endpoint based on the endpoint type.
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
