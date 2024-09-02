//
//  APIEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

final class EndpointProviderTests: XCTestCase {
    struct MockEndpoint: EndpointProvider {
        var baseURL: String
        var path: String
        var queryItems: [URLQueryItem]
    }
    
    func testURLConstruction() {
        let endpoint = MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/v1/resource",
            queryItems: [
                URLQueryItem(name: "param1", value: "value1"),
                URLQueryItem(name: "param2", value: "value2")
            ]
        )
        
        let expectedURL = URL(string: "https://api.example.com/v1/resource?param1=value1&param2=value2")
        XCTAssertEqual(endpoint.url, expectedURL)
    }
    
    func testURLConstructionWithInvalidBaseURL() {
        let endpoint = MockEndpoint(
            baseURL: "invalid_url",
            path: "/v1/resource",
            queryItems: []
        )
        
        XCTAssertNil(endpoint.url)
    }
    
    func testURLConstructionWithoutSchemeOrHost() {
        let endpoint = MockEndpoint(
            baseURL: "example.com/v1/resource",
            path: "",
            queryItems: []
        )
        
        XCTAssertNil(endpoint.url)
    }
    
    func testURLConstructionWithEmptyPathAndQueryItems() {
        let endpoint = MockEndpoint(
            baseURL: "https://api.example.com",
            path: "",
            queryItems: []
        )
        
        let expectedURL = URL(string: "https://api.example.com")
        XCTAssertEqual(endpoint.url, expectedURL)
    }
    
    func testURLConstructionWithPathWithoutLeadingSlash() {
        let endpoint = MockEndpoint(
            baseURL: "https://api.example.com",
            path: "v1/resource",
            queryItems: []
        )
        
        let expectedURL = URL(string: "https://api.example.com/v1/resource")
        XCTAssertEqual(endpoint.url, expectedURL)
    }
}

final class APIKeyProviderTests: XCTestCase {
    struct MockAPIKeyProvider: APIKeyProvider {
        var apiKey: String
    }
    
    func testAPIKey() {
        let apiKeyProvider = MockAPIKeyProvider(apiKey: "test_api_key")
        XCTAssertEqual(apiKeyProvider.apiKey, "test_api_key")
    }
}
