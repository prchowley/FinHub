//
//  APIEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

class MockEndpoint: EndpointProvider {
    var baseURL: String
    var apiKey: String
    var path: String
    var queryItems: [URLQueryItem]
    
    init(baseURL: String, apiKey: String, path: String, queryItems: [URLQueryItem]) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.path = path
        self.queryItems = queryItems
    }
}

// A concrete implementation for testing purposes
struct TestEndpoint: EndpointProvider {
    var baseURL: String
    var apiKey: String
    var path: String
    var queryItems: [URLQueryItem]
}

class EndpointProviderTests: XCTestCase {
    
    func testURLConstruction() {
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
        
        let expectedURLString = "https://example.com/test/path?key=value&anotherKey=anotherValue"
        
        XCTAssertEqual(endpoint.url?.absoluteString, expectedURLString)
    }
}
