//
//  AlphaVantageEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// Unit tests for `AlphaVantageEndpoint` functionality.
class AlphaVantageEndpointTests: XCTestCase {

    /// A mock implementation of `KeyService` for testing purposes.
    private class MockKeyService: KeyService {
        /// Retrieves a mock API key.
        /// - Parameter type: The type of key to retrieve.
        /// - Returns: A mock API key.
        func get(for type: FinHub.KeyType) -> String {
            return "mock_api_key"
        }
        
        /// Saves a token. This method does nothing in the mock implementation.
        /// - Parameters:
        ///   - token: The token to save.
        ///   - type: The type of key to save.
        func save(token: String, for type: FinHub.KeyType) { }
    }
    
    /// An instance of the mock key service for use in tests.
    private let mockKeyService = MockKeyService()

    /// Tests the `AlphaVantageEndpoint` URL construction with an interval.
    func testGraphEndpointWithInterval() {
        // Given
        let function = GraphFunction.TIME_SERIES_INTRADAY
        let symbol = "AAPL"
        let interval = GraphInterval.min1
        // When
        let endpoint = AlphaVantageEndpoint(function: function, symbol: symbol, interval: interval, keyService: mockKeyService)
        let request = endpoint.urlRequest()
        
        // Then
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        XCTAssertEqual(request?.url?.absoluteString, "https://www.alphavantage.co/query?function=\(function.rawValue)&symbol=\(symbol)&apikey=mock_api_key&interval=\(interval.rawValue)", "Expected the URL string to match")
    }

    /// Tests the `AlphaVantageEndpoint` URL construction without an interval.
    func testGraphEndpointWithoutInterval() {
        // Given
        let function = GraphFunction.TIME_SERIES_DAILY
        let symbol = "AAPL"
        let interval = GraphInterval.min30 // Assuming this is not used for this function
        // When
        let endpoint = AlphaVantageEndpoint(function: function, symbol: symbol, interval: interval, keyService: mockKeyService)
        let request = endpoint.urlRequest()
        
        // Then
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        XCTAssertEqual(request?.url?.absoluteString, "https://www.alphavantage.co/query?function=\(function.rawValue)&symbol=\(symbol)&apikey=mock_api_key", "Expected the URL string to match")
    }
}
