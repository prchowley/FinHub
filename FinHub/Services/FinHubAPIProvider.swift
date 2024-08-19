//
//  FinHubAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

protocol FinhubAPIService {
    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], Error>) -> Void)
    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, Error>) -> Void)
    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, Error>) -> Void)
    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void)
}

class FinHubAPIProvider: FinhubAPIService {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }

    func fetchStockSymbols(completion: @escaping (Result<[StockSymbol], Error>) -> Void) {
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .stockSymbols), completion: completion)
    }

    func searchStocks(query: String, completion: @escaping (Result<StockSearchResult, Error>) -> Void) {
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .search(query: query)), completion: completion)
    }

    func fetchCompanyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, Error>) -> Void) {
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .companyProfile(symbol: symbol)), completion: completion)
    }

    func fetchStockQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        httpClient.request(endpoint: FinnhubEndpoint(endpointType: .quote(symbol: symbol)), completion: completion)
    }
}
