//
//  AlphaVantageEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class AlphaVantageEndpointTests: XCTestCase {

    private class MockKeyService: KeyService {
        func get(for type: FinHub.KeyType) -> String {
            return "mock_api_key"
        }
        
        func save(token: String, for type: FinHub.KeyType) { }
    }
    
    private let mockKeyService = MockKeyService()

    func testGraphEndpointWithInterval() {
        let function = GraphFunction.TIME_SERIES_INTRADAY
        let symbol = "AAPL"
        let interval = GraphInterval.min1
        let endpoint = AlphaVantageEndpoint(function: function, symbol: symbol, interval: interval, keyService: mockKeyService)
        let request = endpoint.urlRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.alphavantage.co/query?function=\(function.rawValue)&symbol=\(symbol)&apikey=mock_api_key&interval=\(interval.rawValue)")
    }

    func testGraphEndpointWithoutInterval() {
        let function = GraphFunction.TIME_SERIES_DAILY
        let symbol = "AAPL"
        let interval = GraphInterval.min30 // Assuming this is not used for this function
        let endpoint = AlphaVantageEndpoint(function: function, symbol: symbol, interval: interval, keyService: mockKeyService)
        let request = endpoint.urlRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.alphavantage.co/query?function=\(function.rawValue)&symbol=\(symbol)&apikey=mock_api_key")
    }
}
