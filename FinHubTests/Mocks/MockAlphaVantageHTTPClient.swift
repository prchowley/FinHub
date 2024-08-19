//
//  MockAlphaVantageHTTPClient.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation
@testable import FinHub

class MockAlphaVantageHTTPClient: HTTPClientProtocol {
    enum MockData {
        case alphaGraphData(AlphaGraphData)
        case error(Error)
    }

    var requestCalled = false
    var mockData: MockData?

    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void) {
        requestCalled = true

        guard let mockData = mockData else {
            // No mock data provided, return an error
            completion(.failure(NSError(domain: "MockHTTPClientError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])))
            return
        }

        switch mockData {
        case .alphaGraphData(let graphData):
            let result: Result<T, Error> = .success(graphData as! T)
            completion(result)

        case .error(let error):
            let result: Result<T, Error> = .failure(error)
            completion(result)
        }
    }
}
