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
    /// - Returns: The decoded response of the request.
    func request<T: Decodable>(endpoint: EndpointProvider) async throws -> T {
        // Indicate that the request method was called.
        requestCalled = true

        guard let mockData = mockData else {
            // No mock data provided, throw an error.
            throw NetworkError.unknown(error: NSError(domain: "MockHTTPClientError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }

        switch mockData {
        case .alphaGraphData(let graphData):
            // Cast the mock data to the expected type and return success.
            guard let result = graphData as? T else {
                throw NetworkError.decodingError
            }
            return result

        case .error(let error):
            // Throw the provided error.
            throw error
        }
    }
}
