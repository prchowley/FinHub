//
//  MockHTTPClient.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

// MARK: - MockHTTPClient

/// A mock implementation of `HTTPClientProtocol` used for unit testing.
///
/// This mock client simulates HTTP requests for various types of data related to stocks,
/// including stock symbols, search results, company profiles, and stock quotes. It also handles
/// error scenarios to test how different components handle various network conditions.
class MockHTTPClient: HTTPClientProtocol {
    
    /// Enum representing the mock data that can be returned by the mock client.
    enum MockData {
        case stockSymbols([StockSymbol])
        case stockSearchResult(StockSearchResult)
        case companyProfile(CompanyProfile)
        case stockQuote(StockQuote)
        case error(NetworkError)
        case image(Data)
    }

    /// A flag indicating whether the `request` method was called.
    ///
    /// This property is useful for verifying that the mock client was used as expected during tests.
    var requestCalled = false
    
    /// The mock data to be returned by the client.
    ///
    /// This property can be set to control the behavior of the mock client in tests.
    var mockData: MockData?

    /// Simulates sending a network request and returns a mock response asynchronously.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to which the request is sent.
    /// - Returns: The decoded response.
    /// - Throws: `NetworkError` if an error occurs during the request.
    func request<T: Decodable>(endpoint: EndpointProvider) async throws -> T {
        // Indicate that the request method was called.
        requestCalled = true

        guard let mockData = mockData else {
            // No mock data provided, throw an unknown error.
            throw NetworkError.unknown(error: NSError(domain: "MockHTTPClientError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }

        switch mockData {
        case .stockSymbols(let symbols):
            // Cast the mock data to the expected type and return success.
            if let result = symbols as? T {
                return result
            } else {
                throw NetworkError.decodingError
            }

        case .stockSearchResult(let searchResult):
            // Cast the mock data to the expected type and return success.
            if let result = searchResult as? T {
                return result
            } else {
                throw NetworkError.decodingError
            }

        case .companyProfile(let profile):
            // Cast the mock data to the expected type and return success.
            if let result = profile as? T {
                return result
            } else {
                throw NetworkError.decodingError
            }

        case .stockQuote(let quote):
            // Cast the mock data to the expected type and return success.
            if let result = quote as? T {
                return result
            } else {
                throw NetworkError.decodingError
            }
            
        case .image(let image):
            if let result = image as? T {
                return result
            } else {
                throw NetworkError.decodingError
            }

        case .error(let error):
            // Throw the provided error.
            throw error
        }
    }
}
