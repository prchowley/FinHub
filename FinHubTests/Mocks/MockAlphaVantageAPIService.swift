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
    ///   - completion: A closure that is called with the result of the request. It provides either
    ///     the graph data or an error.
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, NetworkError>) -> Void) {
        // Simulate a delay to mimic real network response time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch self.mockData {
            case .success(let graphData):
                // Return the simulated successful data.
                completion(.success(graphData))
            case .error(let error):
                // Return the simulated error.
                completion(.failure(error))
            case .none:
                // Return a default error if no mock data is provided.
                let error = NSError(domain: "MockAlphaVantageAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
