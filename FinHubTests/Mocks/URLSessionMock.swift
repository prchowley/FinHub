//
//  URLSessionMock.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub

// MARK: - Mock URLSession and URLSessionDataTask
final class URLSessionMock: URLSessionProtocol {
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
