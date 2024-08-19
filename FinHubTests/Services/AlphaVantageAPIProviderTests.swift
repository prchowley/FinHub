//
//  AlphaVantageAPIProviderTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class AlphaVantageAPIProviderTests: XCTestCase {
    var apiProvider: AlphaVantageAPIProvider!
    var mockHTTPClient: MockAlphaVantageHTTPClient!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockAlphaVantageHTTPClient()
        apiProvider = AlphaVantageAPIProvider(httpClient: mockHTTPClient)
    }

    func testGraphDataSuccess() {
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
                "2024-08-18 09:00:00": GraphDataTimeSeries(open: "175.00", high: "177.00", low: "174.50", close: "176.00", volume: "1000000")
            ]
        ]
        
        let expectedData = AlphaGraphData(metaData: metaData, timeSeries: timeSeries)
        mockHTTPClient.mockData = .alphaGraphData(expectedData)
        
        let symbol = "AAPL"
        let frequency = GraphFunction.TIME_SERIES_INTRADAY
        let interval = GraphInterval.min1
        
        // Act
        apiProvider.graphData(of: symbol, with: frequency, and: interval) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }

    func testGraphDataFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockHTTPClient.mockData = .error(testError)
        
        let symbol = "AAPL"
        let frequency = GraphFunction.TIME_SERIES_INTRADAY
        let interval = GraphInterval.min1
        
        // Act
        apiProvider.graphData(of: symbol, with: frequency, and: interval) { result in
            switch result {
            case .success(let data):
                XCTFail("Expected failure but got data: \(data)")
            case .failure(let error):
                XCTAssertEqual(error as NSError, testError)
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }
}
