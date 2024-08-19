//
//  FinnhubEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// Unit tests for `FinnhubEndpoint` functionality.
class FinnhubEndpointTests: XCTestCase {

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
    
    /// Tests the `stockSymbols` endpoint URL construction.
    func testStockSymbolsEndpoint() {
        // Create the endpoint for stock symbols
        let endpoint = FinnhubEndpoint(endpointType: .stockSymbols, keyService: mockKeyService)
        // Get the URL request
        let request = endpoint.urlRequest()
        
        // Verify the URL request is not nil
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        // Verify the URL string is as expected
        XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/stock/symbol?token=mock_api_key&exchange=US&currency=USD", "Expected the URL string to match")
    }
    
    /// Tests the `search` endpoint URL construction.
    func testSearchEndpoint() {
        let query = "AAPL"
        // Create the endpoint for search with the query
        let endpoint = FinnhubEndpoint(endpointType: .search(query: query), keyService: mockKeyService)
        // Get the URL request
        let request = endpoint.urlRequest()
        
        // Verify the URL request is not nil
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        // Verify the URL string is as expected
        XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/search?token=mock_api_key&q=\(query)", "Expected the URL string to match")
    }
    
    /// Tests the `companyProfile` endpoint URL construction.
    func testCompanyProfileEndpoint() {
        let symbol = "AAPL"
        // Create the endpoint for company profile with the symbol
        let endpoint = FinnhubEndpoint(endpointType: .companyProfile(symbol: symbol), keyService: mockKeyService)
        // Get the URL request
        let request = endpoint.urlRequest()
        
        // Verify the URL request is not nil
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        // Verify the URL string is as expected
        XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/stock/profile2?token=mock_api_key&symbol=\(symbol)", "Expected the URL string to match")
    }
    
    /// Tests the `quote` endpoint URL construction.
    func testQuoteEndpoint() {
        let symbol = "AAPL"
        // Create the endpoint for quote with the symbol
        let endpoint = FinnhubEndpoint(endpointType: .quote(symbol: symbol), keyService: mockKeyService)
        // Get the URL request
        let request = endpoint.urlRequest()
        
        // Verify the URL request is not nil
        XCTAssertNotNil(request, "Expected the URL request to be non-nil")
        // Verify the URL string is as expected
        XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/quote?token=mock_api_key&symbol=\(symbol)", "Expected the URL string to match")
    }
}
