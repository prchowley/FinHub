//
//  URLSessionMock.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub

// MARK: - Mock Implementation of URLSessionProtocol

/// A mock implementation of `URLSessionProtocol` for testing purposes.
/// It allows you to provide mock data, response, and error to simulate different network scenarios.
final class URLSessionMock: URLSessionProtocol {
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: Error?
    
    /// Initializes a new instance of `URLSessionMock`.
    /// - Parameters:
    ///   - data: The mock data to return in the completion handler.
    ///   - response: The mock URL response to return in the completion handler.
    ///   - error: The mock error to return in the completion handler.
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    
    /// Creates a mock data task that immediately calls the completion handler with mock data.
    /// - Parameters:
    ///   - url: The URL for the data task (ignored in this mock).
    ///   - completionHandler: The completion handler to call with mock data, response, and error.
    /// - Returns: A mock `URLSessionDataTaskProtocol` that triggers the completion handler.
    func data(from url: URL) async throws -> (Data, URLResponse) {
        // Simulate a delay to mimic real network response time.
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.noData
        }
        
        return (data, response)
    }
}
