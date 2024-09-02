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
    /// - Returns: An array of `StockSymbol` objects.
    func fetchStockSymbols() async throws -> [StockSymbol] {
        try await handleMockData()
    }
    
    /// Simulates searching for stocks based on a query.
    ///
    /// - Parameter query: The search query to find stocks.
    /// - Returns: A `StockSearchResult` object.
    func searchStocks(query: String) async throws -> StockSearchResult {
        try await handleMockData()
    }
    
    /// Simulates fetching a company profile for a given stock symbol.
    ///
    /// - Parameter symbol: The stock symbol for which to fetch the company profile.
    /// - Returns: A `CompanyProfile` object.
    func fetchCompanyProfile(symbol: String) async throws -> CompanyProfile {
        switch mockData {
        case .companyProfile(let profile):
            return profile
        case .error(let error):
            throw NetworkError.unknown(error: error)
        default:
            throw NetworkError.unknown(error: NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }
    }
    
    /// Simulates fetching a stock quote for a given stock symbol.
    ///
    /// - Parameter symbol: The stock symbol for which to fetch the stock quote.
    /// - Returns: A `StockQuote` object.
    func fetchStockQuote(symbol: String) async throws -> StockQuote {
        switch mockData {
        case .stockQuote(let quote):
            return quote
        case .error(let error):
            throw NetworkError.unknown(error: error)
        default:
            throw NetworkError.unknown(error: NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }
    }
    
    /// Handles the mock data for various requests.
    ///
    /// - Returns: A result containing either the decoded response or an error.
    ///
    /// This method is used internally by `fetchStockSymbols` and `searchStocks` to simplify handling
    /// the mock data.
    private func handleMockData<T>() async throws -> T {
        guard let mockData = mockData else {
            throw NetworkError.unknown(error: NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"]))
        }
        
        switch mockData {
        case .stockSymbols(let symbols):
            return symbols as! T
        case .stockSearchResult(let searchResult):
            return searchResult as! T
        case .companyProfile(let profile):
            return profile as! T
        case .stockQuote(let quote):
            return quote as! T
        case .error(let error):
            throw NetworkError.unknown(error: error)
        }
    }
}
