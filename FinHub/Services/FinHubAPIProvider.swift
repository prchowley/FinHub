//
//  FinHubAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

// MARK: - FinhubAPIService

/// Protocol defining the methods for interacting with the Finnhub API.
protocol FinhubAPIService {
    func fetchStockSymbols() async throws -> [StockSymbol]
    func searchStocks(query: String) async throws -> StockSearchResult
    func fetchCompanyProfile(symbol: String) async throws -> CompanyProfile
    func fetchStockQuote(symbol: String) async throws -> StockQuote
}

// MARK: - FinHubAPIProvider

/// Class that conforms to `FinhubAPIService` and uses an `HTTPClientProtocol` to perform network operations.
class FinHubAPIProvider: FinhubAPIService {
    
    /// The HTTP client used for making network requests.
    private let httpClient: HTTPClientProtocol

    /// Initializes the `FinHubAPIProvider` with a specified HTTP client.
    /// - Parameter httpClient: The HTTP client used to make network requests.
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    /// Fetches stock symbols from the API.
    /// - Returns: An array of `StockSymbol` objects.
    func fetchStockSymbols() async throws -> [StockSymbol] {
        return try await httpClient.request(endpoint: FinnhubEndpoint(endpointType: .stockSymbols))
    }

    /// Searches for stocks based on a query string.
    /// - Parameter query: The search query string.
    /// - Returns: A `StockSearchResult` object.
    func searchStocks(query: String) async throws -> StockSearchResult {
        return try await httpClient.request(endpoint: FinnhubEndpoint(endpointType: .search(query: query)))
    }

    /// Fetches the company profile for a given stock symbol.
    /// - Parameter symbol: The stock symbol for which to fetch the profile.
    /// - Returns: A `CompanyProfile` object.
    func fetchCompanyProfile(symbol: String) async throws -> CompanyProfile {
        return try await httpClient.request(endpoint: FinnhubEndpoint(endpointType: .companyProfile(symbol: symbol)))
    }

    /// Fetches the stock quote for a given stock symbol.
    /// - Parameter symbol: The stock symbol for which to fetch the quote.
    /// - Returns: A `StockQuote` object.
    func fetchStockQuote(symbol: String) async throws -> StockQuote {
        return try await httpClient.request(endpoint: FinnhubEndpoint(endpointType: .quote(symbol: symbol)))
    }
}
