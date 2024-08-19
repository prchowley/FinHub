//
//  AlphaVantageAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Protocol defining the method for fetching graph data from the Alpha Vantage API.
protocol AlphaVantageAPIService {
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, Error>) -> Void)
}

/// Class that conforms to `AlphaVantageAPIService` and uses an `HTTPClientProtocol` to perform network operations.
class AlphaVantageAPIProvider: AlphaVantageAPIService {
    
    /// The HTTP client used for making network requests.
    private let httpClient: HTTPClientProtocol

    /// Initializes the `AlphaVantageAPIProvider` with a specified HTTP client.
    /// - Parameter httpClient: The HTTP client used to make network requests. Defaults to a new `HTTPClient` instance.
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }

    /// Fetches graph data for a given stock symbol with specified frequency and interval.
    /// - Parameters:
    ///   - stockSymbol: The stock symbol for which to fetch graph data.
    ///   - frequency: The frequency of the data (e.g., daily, weekly).
    ///   - interval: The interval for the data (e.g., 1min, 5min).
    ///   - completion: A closure that is called with the result of the request.
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, Error>) -> Void) {
        // Requests graph data from the API using the `AlphaVantageEndpoint` for the given function, symbol, and interval.
        httpClient.request(endpoint: AlphaVantageEndpoint(function: frequency, symbol: stockSymbol, interval: interval), completion: completion)
    }
}
