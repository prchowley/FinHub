//
//  AlphaVantageAPIProviderTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

// MARK: - AlphaVantageAPIProviderTests

/// Unit tests for the `AlphaVantageAPIProvider` class.
///
/// This test class validates the behavior and functionality of `AlphaVantageAPIProvider`
/// under different conditions such as successful data retrieval and handling of failure scenarios.
class AlphaVantageAPIProviderTests: XCTestCase {

    /// The `AlphaVantageAPIProvider` instance under test.
    var apiProvider: AlphaVantageAPIProvider!

    /// Mock implementation of `HTTPClientProtocol` used for testing.
    var mockHTTPClient: MockAlphaVantageHTTPClient!

    override func setUp() async throws {
        try await super.setUp()
        
        // Initialize the mock HTTP client and API provider before each test.
        mockHTTPClient = MockAlphaVantageHTTPClient()
        apiProvider = AlphaVantageAPIProvider(httpClient: mockHTTPClient)
    }

    /// Tests successful retrieval of graph data from the API provider.
    ///
    /// Simulates a successful API response and verifies that the `AlphaVantageAPIProvider`
    /// correctly handles and returns the expected data.
    func testGraphDataSuccess() async {
        // Arrange
        let metaData = MetaData(
            information: "Information",
            symbol: "AAPL",
            lastRefreshed: "2024-08-18",
            interval: "1min",
            outputSize: "Compact",
            timeZone: "US/Eastern"
        )
        
        let timeSeries = [
            AlphaGraphKeyType.interval(.min1): [
                "2024-08-18 09:00:00": GraphDataTimeSeries(
                    open: "175.00",
                    high: "177.00",
                    low: "174.50",
                    close: "176.00",
                    volume: "1000000"
                )
            ]
        ]
        
        let expectedData = AlphaGraphData(metaData: metaData, timeSeries: timeSeries)
        mockHTTPClient.mockData = .alphaGraphData(expectedData)
        
        let symbol = "AAPL"
        let frequency = GraphFunction.TIME_SERIES_INTRADAY
        let interval = GraphInterval.min1
        
        // Act
        do {
            let data = try await apiProvider.graphData(of: symbol, with: frequency, and: interval)
            
            // Assert
            XCTAssertEqual(data, expectedData, "The retrieved data should match the expected data")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "HTTP request should have been made")
    }

    /// Tests failure handling of the API provider.
    ///
    /// Simulates an error response from the HTTP client and verifies that the `AlphaVantageAPIProvider`
    /// correctly handles and returns the appropriate error.
    func testGraphDataFailure() async {
        // Arrange
        let testError = NetworkError.unknown(error: NSError(domain: "TestError", code: 1, userInfo: nil))
        mockHTTPClient.mockData = .error(.unknown(error: testError))
        
        let symbol = "AAPL"
        let frequency = GraphFunction.TIME_SERIES_INTRADAY
        let interval = GraphInterval.min1
        
        // Act
        do {
            _ = try await apiProvider.graphData(of: symbol, with: frequency, and: interval)
            XCTFail("Expected failure but got data")
        } catch {
            // Assert
            XCTAssertEqual(error as! NetworkError, testError, "The error should match the expected error")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "HTTP request should have been made")
    }
}
