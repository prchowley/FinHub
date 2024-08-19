//
//  HTTPClientTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// A test suite for verifying the behavior of the `HTTPClient` class.
///
/// This class contains tests to ensure that the `HTTPClient` handles various network scenarios correctly,
/// including successful requests and different types of failures.
class HTTPClientTests: XCTestCase {
    
    /// The HTTP client being tested.
    private var httpClient: HTTPClient!
    
    /// Sets up the testing environment for each test case.
    ///
    /// This method is called before the invocation of each test method in the class.
    /// It initializes the `HTTPClient` with a mock URL session.
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(urlSession: URLSessionMock(data: nil, response: nil, error: nil), decoder: JSONDecoder())
    }
    
    /// Tests a successful network request.
    ///
    /// This test verifies that the `HTTPClient` can successfully handle a request with valid data,
    /// and that the response data is decoded correctly.
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
    
    /// Tests a network request failure due to an invalid URL.
    ///
    /// This test verifies that the `HTTPClient` handles cases where the provided URL is invalid,
    /// and that the correct error is returned.
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
    
    /// Tests a network request failure due to no data being received.
    ///
    /// This test verifies that the `HTTPClient` correctly handles cases where the server returns no data,
    /// and that the appropriate error is returned.
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
    
    /// Tests a network request failure due to decoding errors.
    ///
    /// This test verifies that the `HTTPClient` handles cases where the response data cannot be decoded,
    /// and that the correct decoding error is returned.
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
