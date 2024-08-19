//
//  MockHTTPClient.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

class MockHTTPClient: HTTPClientProtocol {
    enum MockData {
        case stockSymbols([StockSymbol])
        case stockSearchResult(StockSearchResult)
        case companyProfile(CompanyProfile)
        case stockQuote(StockQuote)
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
        case .stockSymbols(let symbols):
                let result: Result<T, Error> = .success(symbols as! T)
                completion(result)

        case .stockSearchResult(let searchResult):
                let result: Result<T, Error> = .success(searchResult as! T)
                completion(result)

        case .companyProfile(let profile):
                let result: Result<T, Error> = .success(profile as! T)
                completion(result)

        case .stockQuote(let quote):
                let result: Result<T, Error> = .success(quote as! T)
                completion(result)

        case .error(let error):
                let result: Result<T, Error> = .failure(error)
                completion(result)
        }
    }
}
