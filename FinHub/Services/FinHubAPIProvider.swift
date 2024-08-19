//
//  FinHubAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

/// Protocol defining the methods for interacting with the Finnhub API.
protocol FinhubAPIService {
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], Error>) -> Void)
    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, Error>) -> Void)
    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, Error>) -> Void)
    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void)
}

/// Class that conforms to `FinhubAPIService` and uses an `HTTPClientProtocol` to perform network operations.
class FinHubAPIProvider: FinhubAPIService {
    
    /// The HTTP client used for making network requests.
    private let httpClient: HTTPClientProtocol

    /// Initializes the `FinHubAPIProvider` with a specified HTTP client.
    /// - Parameter httpClient: The HTTP client used to make network requests. Defaults to a new `HTTPClient` instance.
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }

    /// Fetches stock symbols from the API.
    /// - Parameter completion: A closure that is called with the result of the request.
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], Error>) -> Void) {
        // Requests stock symbols from the API using the `FinnhubEndpoint` for stock symbols.
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .stockSymbols), completion: completion)
    }

    /// Searches for stocks based on a query string.
    /// - Parameter query: The search query string.
    /// - Parameter completion: A closure that is called with the result of the request.
    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, Error>) -> Void) {
        // Requests stock search results from the API using the `FinnhubEndpoint` for search.
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .search(query: query)), completion: completion)
    }

    /// Fetches the company profile for a given stock symbol.
    /// - Parameter symbol: The stock symbol for which to fetch the profile.
    /// - Parameter completion: A closure that is called with the result of the request.
    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, Error>) -> Void) {
        // Requests company profile information from the API using the `FinnhubEndpoint` for company profile.
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .companyProfile(symbol: symbol)), completion: completion)
    }

    /// Fetches the stock quote for a given stock symbol.
    /// - Parameter symbol: The stock symbol for which to fetch the quote.
    /// - Parameter completion: A closure that is called with the result of the request.
    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        // Requests stock quote information from the API using the `FinnhubEndpoint` for stock quotes.
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .quote(symbol: symbol)), completion: completion)
    }
}
