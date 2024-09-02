//
//  AlphaVantageAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

// MARK: - AlphaVantageAPIService

/// Protocol defining the method for fetching graph data from the Alpha Vantage API.
protocol AlphaVantageAPIService {
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval) async throws -> AlphaGraphData
}

// MARK: - AlphaVantageAPIProvider

/// Class that conforms to `AlphaVantageAPIService` and uses an `HTTPClientProtocol` to perform network operations.
class AlphaVantageAPIProvider: AlphaVantageAPIService {
    
    /// The HTTP client used for making network requests.
    private let httpClient: HTTPClientProtocol

    /// Initializes the `AlphaVantageAPIProvider` with a specified HTTP client.
    /// - Parameter httpClient: The HTTP client used to make network requests.
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    /// Fetches graph data for a given stock symbol with specified frequency and interval.
    /// - Parameters:
    ///   - stockSymbol: The stock symbol for which to fetch graph data.
    ///   - frequency: The frequency of the data (e.g., daily, weekly).
    ///   - interval: The interval for the data (e.g., 1min, 5min).
    /// - Returns: The `AlphaGraphData` object containing the graph data.
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval) async throws -> AlphaGraphData {
        return try await httpClient.request(endpoint: AlphaVantageEndpoint(function: frequency, symbol: stockSymbol, interval: interval))
    }
}
