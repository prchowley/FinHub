//
//  MockAlphaVantageHTTPClient.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation
@testable import FinHub

// MARK: - MockAlphaVantageHTTPClient

/// A mock implementation of `HTTPClientProtocol` used for unit testing.
///
/// This mock client simulates HTTP requests to test how the `AlphaVantageAPIProvider` handles
/// different network conditions, including successful data retrieval and error scenarios.
class MockAlphaVantageHTTPClient: HTTPClientProtocol {
    
    /// Enum representing the mock data that can be returned by the mock client.
    enum MockData {
        case alphaGraphData(AlphaGraphData)
        case error(NetworkError)
    }

    /// A flag indicating whether the `request` method was called.
    ///
    /// This property is useful for verifying that the mock client was used as expected during tests.
    var requestCalled = false
    
    /// The mock data to be returned by the client.
    ///
    /// This property can be set to control the behavior of the mock client in tests.
    var mockData: MockData?

    /// Simulates sending a network request and returns a mock response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to which the request is sent.
    ///   - completion: A closure that is called with the result of the request. It provides either
    ///     the decoded response or an error.
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, NetworkError>) -> Void) {
        // Indicate that the request method was called.
        requestCalled = true

        guard let mockData = mockData else {
            // No mock data provided, return a default error.
            let error = NSError(domain: "MockHTTPClientError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
            completion(.failure(.unknown(error: error)))
            return
        }

        switch mockData {
        case .alphaGraphData(let graphData):
            // Cast the mock data to the expected type and return success.
            let result: Result<T, NetworkError> = .success(graphData as! T)
            completion(result)

        case .error(let error):
            // Return the provided error.
            let result: Result<T, NetworkError> = .failure(.unknown(error: error))
            completion(result)
        }
    }
}
