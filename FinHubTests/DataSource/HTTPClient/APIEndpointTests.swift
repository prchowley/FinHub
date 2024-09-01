//
//  APIEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

/// A mock implementation of `EndpointProvider` for testing purposes.
class MockEndpoint: EndpointProvider, APIKeyProvider {
    /// The base URL for the endpoint.
    var baseURL: String
    /// The API key for accessing the endpoint.
    var apiKey: String
    /// The path component of the endpoint URL.
    var path: String
    /// The query items to be included in the endpoint URL.
    var queryItems: [URLQueryItem]
    
    /// Initializes a new instance of `MockEndpoint`.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the endpoint.
    ///   - apiKey: The API key for accessing the endpoint.
    ///   - path: The path component of the endpoint URL.
    ///   - queryItems: The query items to be included in the endpoint URL.
    init(baseURL: String, apiKey: String, path: String, queryItems: [URLQueryItem]) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.path = path
        self.queryItems = queryItems
    }
}

/// A concrete implementation of `EndpointProvider` for testing purposes.
struct TestEndpoint: EndpointProvider, APIKeyProvider {
    /// The base URL for the endpoint.
    var baseURL: String
    /// The API key for accessing the endpoint.
    var apiKey: String
    /// The path component of the endpoint URL.
    var path: String
    /// The query items to be included in the endpoint URL.
    var queryItems: [URLQueryItem]
}

/// Unit tests for `EndpointProvider` implementations.
class EndpointProviderTests: XCTestCase {
    
    /// Tests the URL construction of an `EndpointProvider`.
    func testURLConstruction() {
        // Arrange: Set up the query items and endpoint
        let queryItems = [
            URLQueryItem(name: "key", value: "value"),
            URLQueryItem(name: "anotherKey", value: "anotherValue")
        ]
        let endpoint = TestEndpoint(
            baseURL: "https://example.com",
            apiKey: "test_api_key",
            path: "/test/path",
            queryItems: queryItems
        )
        
        // The expected URL string after construction
        let expectedURLString = "https://example.com/test/path?key=value&anotherKey=anotherValue"
        
        // Act & Assert: Verify the constructed URL matches the expected URL string
        XCTAssertEqual(endpoint.url?.absoluteString, expectedURLString)
    }
}
