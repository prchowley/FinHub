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
    func createDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return URLSessionDataTaskMock {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
    }
}

// MARK: - Mock Implementation of URLSessionDataTaskProtocol

/// A mock implementation of `URLSessionDataTaskProtocol` for testing purposes.
/// It simulates the behavior of a URLSession data task, allowing you to control when the completion handler is called.
final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    
    /// Initializes a new instance of `URLSessionDataTaskMock`.
    /// - Parameter closure: The closure to call when `resume` is invoked.
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    /// Simulates resuming the data task by calling the provided closure.
    func resume() {
        closure()
    }
    
    /// Simulates canceling the data task.
    /// - Note: This implementation does not handle cancellation. Add logic if needed.
    func cancel() {
        // Optionally handle cancellation if needed
    }
}
