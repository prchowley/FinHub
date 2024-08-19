//
//  HTTPClientTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class HTTPClientTests: XCTestCase {
    
    var httpClient: HTTPClient!
    
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(urlSession: URLSessionMock(data: nil, response: nil, error: nil), decoder: JSONDecoder())
    }
    
    func testRequestSuccess() {
        let mockURL = URL(string: "https://mockapi.com/mockpath")!
        let mockEndpoint = MockEndpoint(
            baseURL: "https://mockapi.com",
            apiKey: "testApiKey",
            path: "/mockpath",
            queryItems: []
        )
        let mockData = """
        {
            "message": "Success"
        }
        """.data(using: .utf8)
        
        let urlSession = URLSessionMock(data: mockData, response: nil, error: nil)
        httpClient = HTTPClient(urlSession: urlSession)
        
        struct MockResponse: Decodable {
            let message: String
        }
        
        let expectation = self.expectation(description: "Completion handler called")
        
        httpClient.request(endpoint: mockEndpoint) { (result: Result<MockResponse, Error>) in
            if case .success(let response) = result {
                XCTAssertEqual(response.message, "Success")
            } else {
                XCTFail("Expected success with valid response")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestFailureInvalidURL() {
        let mockEndpoint = MockEndpoint(
            baseURL: "invalid_url",
            apiKey: "testApiKey",
            path: "/mockpath",
            queryItems: []
        )
        
        let urlSession = URLSessionMock(data: nil, response: nil, error: nil)
        httpClient = HTTPClient(urlSession: urlSession)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        httpClient.request(endpoint: mockEndpoint) { (result: Result<Data, Error>) in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? NetworkError, .invalidURL)
            } else {
                XCTFail("Expected failure with invalid URL")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestFailureNoData() {
        let mockURL = URL(string: "https://mockapi.com/mockpath")!
        let mockEndpoint = MockEndpoint(
            baseURL: "https://mockapi.com",
            apiKey: "testApiKey",
            path: "/mockpath",
            queryItems: []
        )
        
        let urlSession = URLSessionMock(data: nil, response: nil, error: nil)
        httpClient = HTTPClient(urlSession: urlSession)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        httpClient.request(endpoint: mockEndpoint) { (result: Result<Data, Error>) in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? NetworkError, .noData)
            } else {
                XCTFail("Expected failure due to no data")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestFailureDecodingError() {
        let mockURL = URL(string: "https://mockapi.com/mockpath")!
        let mockEndpoint = MockEndpoint(
            baseURL: "https://mockapi.com",
            apiKey: "testApiKey",
            path: "/mockpath",
            queryItems: []
        )
        let mockData = """
        {
            "invalid_key": "Invalid"
        }
        """.data(using: .utf8)
        
        let urlSession = URLSessionMock(data: mockData, response: nil, error: nil)
        httpClient = HTTPClient(urlSession: urlSession)
        
        struct MockResponse: Decodable {
            let message: String
        }
        
        let expectation = self.expectation(description: "Completion handler called")
        
        httpClient.request(endpoint: mockEndpoint) { (result: Result<MockResponse, Error>) in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? NetworkError, .decodingError)
            } else {
                XCTFail("Expected decoding error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
