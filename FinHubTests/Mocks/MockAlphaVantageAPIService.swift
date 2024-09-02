//
//  MockAlphaVantageAPIService.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

// MARK: - MockAlphaVantageAPIService

/// A mock implementation of `AlphaVantageAPIService` used for unit testing.
///
/// This mock service simulates network responses to test how the `AlphaVantageAPIProvider`
/// handles different scenarios, including successful data retrieval and error conditions.
class MockAlphaVantageAPIService: AlphaVantageAPIService {
    
    /// Enum representing the mock data that can be returned by the mock service.
    enum MockData {
        case success(AlphaGraphData)
        case error(NetworkError)
    }
    
    /// The mock data to be returned by the service.
    ///
    /// This property can be set to control the behavior of the mock service in tests.
    var mockData: MockData?
    
    /// Simulates fetching graph data from the API.
    ///
    /// - Parameters:
    ///   - stockSymbol: The stock symbol for which the graph data is requested.
    ///   - frequency: The frequency of the data (e.g., intraday, daily).
    ///   - interval: The interval at which data points are returned (e.g., 1 minute, 5 minutes).
    /// - Returns: The `AlphaGraphData` object containing the graph data.
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval) async throws -> AlphaGraphData {
        // Simulate a delay to mimic real network response time.
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        switch mockData {
        case .success(let graphData):
            // Return the simulated successful data.
            return graphData
        case .error(let error):
            // Throw the simulated error.
            throw error
        case .none:
            // Throw a default error if no mock data is provided.
            throw NetworkError.unknown(error: NSError(domain: "MockAlphaVantageAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }
    }
}
