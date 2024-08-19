//
//  MockFinhubAPIService.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation
@testable import FinHub

class MockFinhubAPIService: FinhubAPIService {
    enum MockData {
        case stockSymbols([StockSymbol])
        case stockSearchResult(StockSearchResult)
        case companyProfile(CompanyProfile)
        case stockQuote(StockQuote)
        case error(Error)
    }
    
    var mockData: MockData?
    
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], Error>) -> Void) {
        handleMockData(completion: completion)
    }
    
    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, Error>) -> Void) {
        handleMockData(completion: completion)
    }
    
    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, Error>) -> Void) {
        if let data = mockData {
            switch data {
            case .companyProfile(let profile):
                completion(.success(profile))
            case .error(let error):
                completion(.failure(error))
            default:
                break
            }
        }
    }
    
    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        if let data = mockData {
            switch data {
            case .stockQuote(let quote):
                completion(.success(quote))
            case .error(let error):
                completion(.failure(error))
            default:
                break
            }
        }
    }
    
    private func handleMockData<T>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let mockData = mockData else {
            completion(.failure(NSError(domain: "MockFinhubAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])))
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
            completion(.failure(error))
        }
    }
}
