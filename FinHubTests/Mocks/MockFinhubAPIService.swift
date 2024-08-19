//
//  MockFinhubAPIService.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation
@testable import FinHub

// MARK: - MockFinhubAPIService

/// A mock implementation of `FinhubAPIService` used for unit testing.
///
/// This mock service simulates network responses for fetching stock symbols, searching stocks,
/// fetching company profiles, and fetching stock quotes. It also handles error scenarios to test
/// how different components handle various network conditions.
class MockFinhubAPIService: FinhubAPIService {
    
    /// Enum representing the mock data that can be returned by the mock service.
    enum MockData {
        case stockSymbols([StockSymbol])
        case stockSearchResult(StockSearchResult)
        case companyProfile(CompanyProfile)
        case stockQuote(StockQuote)
        case error(Error)
    }
    
    /// The mock data to be returned by the service.
    ///
    /// This property can be set to control the behavior of the mock service in tests.
    var mockData: MockData?
    
    /// Simulates fetching stock symbols.
    ///
    /// - Parameter completion: A closure that is called with the result of the request. It provides either
    ///   the fetched stock symbols or an error.
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], NetworkError>) -> Void) {
        handleMockData(completion: completion)
    }
    
    /// Simulates searching for stocks based on a query.
    ///
    /// - Parameters:
    ///   - query: The search query to find stocks.
    ///   - completion: A closure that is called with the result of the request. It provides either
    ///     the search result or an error.
    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, NetworkError>) -> Void) {
        handleMockData(completion: completion)
    }
    
    /// Simulates fetching a company profile for a given stock symbol.
    ///
    /// - Parameters:
    ///   - symbol: The stock symbol for which to fetch the company profile.
    ///   - completion: A closure that is called with the result of the request. It provides either
    ///     the company profile or an error.
    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, NetworkError>) -> Void) {
        if let data = mockData {
            switch data {
            case .companyProfile(let profile):
                completion(.success(profile))
            case .error(let error):
                completion(.failure(.unknown(error: error)))
            default:
                // Handle cases where the mock data does not match.
                break
            }
        } else {
            // No mock data provided, return an error.
            completion(.failure(.unknown(error: NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))))
        }
    }
    
    /// Simulates fetching a stock quote for a given stock symbol.
    ///
    /// - Parameters:
    ///   - symbol: The stock symbol for which to fetch the stock quote.
    ///   - completion: A closure that is called with the result of the request. It provides either
    ///     the stock quote or an error.
    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, NetworkError>) -> Void) {
        if let data = mockData {
            switch data {
            case .stockQuote(let quote):
                completion(.success(quote))
            case .error(let error):
                completion(.failure(.unknown(error: error)))
            default:
                // Handle cases where the mock data does not match.
                break
            }
        } else {
            // No mock data provided, return an error.
            completion(.failure(.unknown(error: NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))))
        }
    }
    
    /// Handles the mock data for various requests.
    ///
    /// - Parameter completion: A closure that is called with the result of the request. It provides either
    ///   the decoded response or an error.
    ///
    /// This method is used internally by `fetchStockSymbols` and `searchStocks` to simplify handling
    /// the mock data.
    private func handleMockData<T>(completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let mockData = mockData else {
            // No mock data provided, return a default error.
            let error = NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
            completion(.failure(.unknown(error: error)))
            return
        }
        
        switch mockData {
        case .stockSymbols(let symbols):
            completion(.success(symbols as! T))
        case .stockSearchResult(let searchResult):
            completion(.success(searchResult as! T))
        case .companyProfile(let profile):
            completion(.success(profile as! T))
        case .stockQuote(let quote):
            completion(.success(quote as! T))
        case .error(let error):
            completion(.failure(.unknown(error: error)))
        }
    }
}
