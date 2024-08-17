//
//  FinHubStockProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

class FinHubStockProvider: FinHubAPIProvider {
    
    let http = HTTPClient()
    
    func fetchSymbols<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void) {
        http.performRequest(endpoint: FinnhubEndpoint.stockSymbols, completion: completion)
    }
    
    func searchSymbols<T: Decodable>(query: String, completion: @escaping (Result<T, Error>) -> Void) {
        http.performRequest(endpoint: FinnhubEndpoint.search(query: query), completion: completion)
    }
    
    func companyProfile<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void) {
        http.performRequest(endpoint: FinnhubEndpoint.companyProfile(symbol: symbol), completion: completion)
    }
    
    func companyQuote<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void) {
        http.performRequest(endpoint: FinnhubEndpoint.quote(symbol: symbol), completion: completion)
    }
    
    func graphData<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void) {
        http.performRequest(endpoint: AlphaVantageEndpoint.graph(f: .TIME_SERIES_DAILY, symbol: symbol, interval: .min5), completion: completion)
    }
}
